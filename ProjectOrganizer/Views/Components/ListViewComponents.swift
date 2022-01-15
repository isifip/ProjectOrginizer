//
//  ListViewComponents.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 15.01.22.
//

import SwiftUI

struct LineSegment: Shape {
    var endPoint: CGPoint
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(endPoint.x, endPoint.y) }
        set { endPoint.x = newValue.first; endPoint.y = newValue.second }
    }
    
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: 0.0, y: 0.0)
        let end = CGPoint(x: endPoint.x * rect.width,
                          y: endPoint.y * rect.height)
        
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}


struct ListViewComponents: View {
    
    @State private var animate = false
    var title = ""
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(.secondary, lineWidth: 2)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.black)
                    .shadow(radius: 10)
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .scaleEffect(animate ? 1.0 : 0)
                    .animation(.spring(), value: animate)
                    .onTapGesture {
                        animate.toggle()
                    }
            }
            //.padding(.leading, 2)
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    Text(title)
                        .overlay {
                            LineSegment(endPoint: CGPoint(
                                x: animate ? 1.0 : 0, y: 0))
                                .stroke(.secondary, lineWidth: 1.5)
                                .frame(height: 1)
                                .animation(.easeInOut(duration: 0.4), value: animate)
                        }
                        //.font(.subheadline)
                }
            }
            .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(2)
        //.background(.ultraThinMaterial)
        .cornerRadius(8)
        //.padding([.horizontal])
    }
}

struct ListViewComponents_Previews: PreviewProvider {
    static var previews: some View {
        ListViewComponents()
            .padding()
    }
}

