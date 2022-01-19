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
        HStack {
            VStack(alignment: .leading) {
                Text("\(project.projectItems.count) Items")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(project.projectTitle)")
                    .font(.title3).fontWeight(.semibold)
            }
            ProgressCircleView(progress: project.completionAmount, color: Color(project.projectColor), widthAndHeight: 70)
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(project: Project.example)
    }
}
