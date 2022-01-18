//
//  HomeView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import CoreData
import SwiftUI

struct HomeView: View {
    
    // tag for Tabview
    static let tag: String? = "Home"
    
    @StateObject var viewModel: HomeViewModel
    
    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    init(dataContoller: DataController) {
        let viewModel = HomeViewModel(dataController: dataContoller)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading) {
                        ItemListView(title: "Up next", items: viewModel.upNext)
                        ItemListView(title: "More to explore", items: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {

                    Button("Add Data", action: viewModel.addSampleData)
               
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var dataController = DataController.preview
    
    static var previews: some View {
        HomeView(dataContoller: .preview)
    }
}
