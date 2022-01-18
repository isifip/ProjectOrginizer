//
//  ExtensionTests.swift
//  ProjectOrganizerTests
//
//  Created by Irakli Sokhaneishvili on 18.01.22.
//

import SwiftUI
import XCTest
@testable import ProjectOrganizer

class ExtensionTests: XCTestCase {
    
    func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
    }
    
    func testSequenceKeyPathSortingCustom() {
        // Given
        struct Example: Equatable {
            let value: String
        }
        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        
        let array = [example1, example2, example3]
        // When
        let sortedItems = array.sorted(by: \.value) {
            $0 > $1
        }
        // Then
        XCTAssertEqual(sortedItems, [example3, example2, example1], "Reverse sorting")
    }
    
    
    func testBindingOnChangeCallsFunction() {
        // Given
        var onChangeFunctionRun = false
        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }
        var storedValue = ""
        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )
        let changedBinding = binding.onChange(exampleFunctionToCall)
        // When
        changedBinding.wrappedValue = "Test"
        // Then
        XCTAssertTrue(onChangeFunctionRun, " The onchange function must be run when the binding is changed")
    }
}

