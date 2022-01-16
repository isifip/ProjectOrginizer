//
//  TabViewTest.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 15.01.22.
//

import SwiftUI

struct TabBar: View {
    
    @SceneStorage("selectedView") var selectedTab: Tab = .home
    @State var color: Color = .blue
    @State var tabItemWidth: CGFloat = 0
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(dataController: _dataController)
                case .open:
                    ProjectsView(showClosedProjects: false)
                case .closed:
                    ProjectsView(showClosedProjects: true)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                buttons
            }
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .frame(height: 88, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
            .overlay(
                overlay
            )
            .strokeStyle(cornerRadius: 34)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
            //.shadow(color: Color("TabForeground").opacity(0.2),radius: 20)
        }
    }
    
    var buttons: some View {
        ForEach(tabItems) { item in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = item.tab
                    color = item.color
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: item.icon)
                        .symbolVariant(.fill)
                        .font(.title2.bold())
                        .frame(width: 44, height: 29)
                    Text(item.text)
                        .font(.caption)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(selectedTab == item.tab ? item.color : Color("TabForeground").opacity(0.7))
            //.blendMode(selectedTab == item.tab ? .overlay : .normal)
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
                }
            )
            .onPreferenceChange(TabPreferenceKey.self) { value in
                tabItemWidth = value
            }
        }
    }
    
    var overlay: some View {
        HStack {
            if selectedTab == .open { Spacer() }
            if selectedTab == .closed {
                Spacer()
                Spacer()
            }
            Rectangle()
                .fill(color)
                .frame(width: 36, height: 5)
                .cornerRadius(3)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
                .offset(y: 4)
            if selectedTab == .home { Spacer() }
            if selectedTab == .open {
                Spacer()
                //Spacer()
            }
            //if selectedTab == .open{ Spacer() }
        }
        .padding(.horizontal, 8)
    }
}

struct TabBar_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        TabBar()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .preferredColorScheme(.light)
    }
}
