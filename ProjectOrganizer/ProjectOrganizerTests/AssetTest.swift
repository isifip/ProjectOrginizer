//
//  AssetTest.swift
//  ProjectOrganizerTests
//
//  Created by Irakli Sokhaneishvili on 18.01.22.
//

import XCTest
@testable import ProjectOrganizer

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog")
        }
    }
}
