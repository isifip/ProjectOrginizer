//
//  ProjectHeaderView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 16.01.22.
//

import SwiftUI

struct ProjectHeaderView: View {
    
    @ObservedObject var project: Project
    
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 5) {
                Text(project.projectTitle)
                    .font(.headline)
                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
            }
            Spacer()
            NavigationLink {
                EditProjectView(project: project)
            } label: {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .imageScale(.medium)
            }
        }
        .padding(.bottom, 10)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
