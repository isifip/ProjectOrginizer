//
//  DataController.swift
//  ProjectOrganizer
//
//  Created by isifip on 14.01.22.
//

import CoreData
import CoreSpotlight
import SwiftUI
import UserNotifications

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch request, tacking awards and dealing with sample data
class DataController: ObservableObject {
    
    /// The loan CloudKit container used to store all our data
    let container: NSPersistentCloudKitContainer
    
    
    /// Init a data controller, either in memory (for temporary use such as testing and previewing).
    /// or on permanent storage (for use in regular app runs.)
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not
    init(inMemory: Bool = false) {
        
        container = NSPersistentCloudKitContainer(name: "Main")
        
        // For testing and previewing, we create temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finished launch
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    
    /// Creates example project and items to make manual testing easier.
    /// - throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for itemCounter in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }
        try viewContext.save()
    }
    
    /// Saves our Core Data context if there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optionals
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: Project) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        
        container.viewContext.delete(object)
    }
    
    func delete(_ object: Item) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func update(_ item: Item) {
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString
        
        let  attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemDetail
        
        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )
        
        CSSearchableIndex.default().indexSearchableItems([searchableItem])
        
        save()
    }
    
    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return try? container.viewContext.existingObject(with: id) as? Item
    }
    
    //MARK: --> Notifications
    func addReminders(for project: Project, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        self.placeReminders(for: project, completion: completion)
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                self.placeReminders(for: project, completion: completion)
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func removeReminders(for project: Project) {
        let center = UNUserNotificationCenter.current()
        let id = project.objectID.uriRepresentation().absoluteString
        
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    
    private func placeReminders(for project: Project, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        
        content.title = project.projectTitle
        content.sound = .default
        
        if let projectDetail = project.detail {
            content.subtitle = projectDetail
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: project.reminderTime ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let id = project.objectID.uriRepresentation().absoluteString
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
