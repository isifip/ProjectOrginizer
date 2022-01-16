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
    
    //MARK: --> Properties
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(
            entity: Project.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
            predicate: NSPredicate(format: "closed = %d", showClosedProjects)
        )
    }
    //MARK: --> Body
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section {
                        ForEach(project.projectItems) { item in
                            ItemRowView(item: item)
                        }
                    } header: {
                        ProjectHeaderView(project: project)
//                        Text(project.projectTitle)
//                            .font(.subheadline).fontWeight(.semibold)
//                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
        }
    }
}
//MARK: --> Preview
struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
