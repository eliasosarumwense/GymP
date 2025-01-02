//
//  ChartBackground.swift
//  GymP
//
//  Created by Elias Osarumwense on 07.08.24.
//

import SwiftUI
import UIKit

struct AreaBackgroundModifier: ViewModifier {
    let gradient: Gradient

    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top)
                    .cornerRadius(10) // Apply rounded corners
                
            )
    }
}

extension View {
    func areaBackground(_ gradient: Gradient) -> some View {
        self.modifier(AreaBackgroundModifier(gradient: gradient))
    }
}

struct CutoutShape: Shape {
    var cutoutRect: CGRect

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        path.addRect(cutoutRect)
        return path
            .strokedPath(.init(lineWidth: 0, dash: [1, 0])) // This ensures the cutout area is applied
    }
}
