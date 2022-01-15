//
//  Tab.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 15.01.22.
//


import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
    var color: Color
}

var tabItems = [
    TabItem(text: "Home", icon: "house", tab: .home, color: .teal),
    TabItem(text: "Open", icon: "list.bullet", tab: .open, color: .blue),
    TabItem(text: "Closed", icon: "checkmark", tab: .closed, color: .red),
]

enum Tab: String {
    case home
    case open
    case closed
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
