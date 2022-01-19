//
//  ProgressCircleView.swift
//  ProjectOrganizer
//
//  Created by Irakli Sokhaneishvili on 19.01.22.
//

import SwiftUI

struct ProgressCircleView: View {
    
    var progress = 1.0
    var color: Color = .blue
    var widthAndHeight: CGFloat = 70
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.ultraThinMaterial, style: StrokeStyle(lineWidth: 3))
                .frame(width: widthAndHeight + 12, height: widthAndHeight + 12)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 5,
                                       lineCap: .round,
                                       lineJoin: .round,
                                       miterLimit: .infinity,
                                       dash: [20, 0],
                                       dashPhase: 0)
                )
                .rotationEffect(Angle(degrees: 270))
                //.rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: widthAndHeight, height: widthAndHeight)
                .shadow(color: .purple.opacity(0.5), radius: 3, x: 0, y: 3)
            Text("\(progress * 100, specifier: "%.0f")%")
                .font(.subheadline.bold())
        }
    }
}

struct ProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircleView()
    }
}
