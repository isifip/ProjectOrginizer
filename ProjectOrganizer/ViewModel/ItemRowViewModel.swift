//
//  ItemRowViewModel.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 18.01.22.
//

import Foundation


extension ItemRowView {
    class ItemRowViewModel: ObservableObject {
        
        let project: Project
        let item: Item
        
        var title: String {
            item.itemTitle
        }
        
        var icon: String {
            if item.completed {
                return "checkmark"
            } else if item.priority == 3 {
                return "exclamationmark"
            } else {
                return "questionmark.circle"
            }
        }
        
        var color: String? {
            if item.completed {
                return project.projectColor
            } else if item.priority == 3 {
                return project.projectColor
            } else {
                return nil
            }
        }
        
        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed"
            } else if item.priority == 3 {
                return "\(item.itemTitle), high priority"
            } else {
                return "\(item.itemTitle)"
            }
        }
        
        init(project: Project, item: Item) {
            self.project = project
            self.item = item
        }
    }
}
