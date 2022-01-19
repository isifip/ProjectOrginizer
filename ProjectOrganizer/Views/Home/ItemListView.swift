//
//  ItemListView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 17.01.22.
//

import SwiftUI

struct ItemListView: View {
    
    let title: String
    let items: ArraySlice<Item>
    
    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    navigationLinkLabelView(item: item)
                }
                Divider()
            }
        }
    }
    func navigationLinkLabelView(item: Item) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 1.4)
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .shadow(radius: 10)
                .padding(2)
            
            VStack(alignment: .leading) {
                Text(item.itemTitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if item.itemDetail.isEmpty == false {
                    Text(item.itemDetail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 8)
            .multilineTextAlignment(.leading)
        }
        //.padding(10)
        //.background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        
    }
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListView()
//    }
//}
