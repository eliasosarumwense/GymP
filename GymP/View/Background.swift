//
//  Background.swift
//  GymP
//
//  Created by Elias Osarumwense on 08.08.24.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

extension View {
    func applyBackground(color: Color) -> some View {
        self.modifier(BackgroundModifier(color: color))
    }
}
