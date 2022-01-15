//
//  Binding-OnChange.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 15.01.22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
