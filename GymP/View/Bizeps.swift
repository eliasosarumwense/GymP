//
//  Bizeos.swift
//  GymP
//
//  Created by Elias Osarumwense on 18.07.24.
//

import Foundation
import SwiftUI

struct BicepHighlight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Starting point at the top center
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // Draw left curve
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.5)
        )
        
        // Draw line to the left bicep
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.5))
        
        // Draw right curve
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.5)
        )
        
        // Draw line to the right bicep
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.5))
        
        path.closeSubpath()
        
        return path
    }
}

