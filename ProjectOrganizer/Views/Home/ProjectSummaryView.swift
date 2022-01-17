//
//  ProjectSummaryView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 17.01.22.
//

import SwiftUI

struct ProjectSummaryView: View {
    
    @ObservedObject var project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(project.projectItems.count)")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(project.projectTitle)")
                .font(.title2).fontWeight(.semibold)
            ProgressView(value: project.completionAmount)
                .tint(Color(project.projectColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 10)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(project: Project.example)
    }
}
