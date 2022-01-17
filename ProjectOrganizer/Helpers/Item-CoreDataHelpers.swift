//
//  Item-CoreDataHelpers.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import Foundation

extension Item {
    // this helps us to avoid optionals in our code
    var itemTitle: String {
        title ?? "New Item"
    }
    var itemDetail: String {
        detail ?? ""
    }
    var itemCreationData: Date {
        creationDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
            item.title = "Example Item"
            item.detail = "This is an example item"
            item.priority = 3
            item.creationDate = Date()
            return item
    }
}
