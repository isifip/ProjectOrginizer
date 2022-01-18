//
//  DevelopmentTests.swift
//  ProjectOrganizerTests
//
//  Created by Irakli Sokhaneishvili on 18.01.22.
//

import CoreData
import XCTest
@testable import ProjectOrganizer

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()
        
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items")
    }
    
    func testDeleteAllFunctionWorks() throws {
        try dataController.createSampleData()
        dataController.deleteAll()
        
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "DeleteALL() should leave 0 projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "DeleteALL() should leave 0 sample items")
    }
    
    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should closed")
    }
    
    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "The example item should be high priority")
    }
}
