//
//  ItemRowView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 15.01.22.
//

import SwiftUI

struct ItemRowView: View {
   
    @StateObject var viewModel: ItemRowViewModel
    @ObservedObject var item: Item
    
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
                    .strikethrough(item.completed ? true : false)
                    .font(.subheadline)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
                    .font(.subheadline)
            }
            //ListViewComponents(item: item)
        }
    }
    init(project: Project, item: Item) {
        let viewModel = ItemRowViewModel(project: project, item: item)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.item = item
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
