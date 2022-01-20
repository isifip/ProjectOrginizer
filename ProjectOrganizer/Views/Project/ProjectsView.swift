//
//  ProjectsView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import SwiftUI

struct ProjectsView: View {
    //tags for TabView
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    
    //MARK: --> ListView
    var projectsList: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }
                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("Add new item", systemImage: "plus")
                        }
                    }
                } header: {
                    ProjectHeaderView(project: project)
                }
            }
        }
        //.listStyle(.insetGrouped)
    }
    //MARK: --> Toolbar Items
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    
    //MARK: --> Main Body
    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There's nothing here right now")
                } else {
                    projectsList
                }
            }
            .navigationBarTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .confirmationDialog("Sort items", isPresented: $showingSortOrder) {
                Button("Optimized") { viewModel.sortOrder = .optimized }
                Button("Creation Date") { viewModel.sortOrder = .creationDate }
                Button("Title") { viewModel.sortOrder = .title }
            }
            SelectSomethingView()
        }
    }
    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
//MARK: --> Preview
struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
    }
}
