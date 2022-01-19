//
//  EditProjectView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 17.01.22.
//

import SwiftUI

struct EditProjectView: View {
    
    @ObservedObject var project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    
    @State private var showingDeleteConfirm = false
    
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
        
        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }
    
    var body: some View {
        Form {
            Section("Basic settings") {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            Section("Custom project color") {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            
            Section("Project reminders") {
                Toggle("Show Reminders", isOn: $remindMe.animation().onChange(update))
                if remindMe {
                    DatePicker(
                        "Reminder time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }
            Section {
                Button {
                    project.closed.toggle()
                    update()
                } label: {
                    Text(project.closed ? "Reopen this project" : "Close this project")
                }
                Button {
                    showingDeleteConfirm.toggle()
                } label: {
                    Text("Delete this project")
                }.tint(.red)
            } footer: {
                Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")
            }
        }
        .navigationTitle("Edit Projects")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project?"),
                message: Text("Are you sure you want to delete this project? You will delete all the items it contains"),
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel())
        }
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
        if remindMe {
            project.reminderTime = reminderTime
        } else {
            project.reminderTime = nil
        }
    }
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
            .environmentObject(DataController())
    }
}
