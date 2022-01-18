//
//  ProjectOrganizerTests.swift
//  ProjectOrganizerTests
//
//  Created by Irakli Sokhaneishvili on 18.01.22.
//

import CoreData
import XCTest
@testable import ProjectOrganizer

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
