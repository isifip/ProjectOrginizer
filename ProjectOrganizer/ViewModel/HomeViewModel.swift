//
//  HomeViewModel.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 18.01.22.
//

import Foundation
import CoreData

extension HomeView {
    class HomeViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>
        
        @Published var projects = [Project]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?
        
        var dataController: DataController
        
        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }
        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            // construct a fetch request to show all open projecets
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.predicate = NSPredicate(format: "closed = false")
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
            
            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            // construct a fetch request to show the 10 highest priority incomplete items from open projects
            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
            
            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            
            itemRequest.predicate = compoundPredicate
            
            itemRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            ]
            
            itemRequest.fetchLimit = 20
            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            projectsController.delegate = self
            itemsController.delegate = self
            
            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            } else if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
        
        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
        
        func selectItem(with identified: String) {
            selectedItem = dataController.item(with: identified)
        }
    }
}
