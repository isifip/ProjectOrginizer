//
//  ProjectOrganizerApp.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import SwiftUI

@main
struct ProjectOrganizerApp: App {
    
    @StateObject var dataContoller: DataController
    
    init() {
        let dataController = DataController()
        _dataContoller = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataContoller.container.viewContext)
                .environmentObject(dataContoller)
        }
    }
}
