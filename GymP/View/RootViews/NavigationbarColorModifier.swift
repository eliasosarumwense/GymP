//
//  NavigationbarColorModifier.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//

import SwiftUI

struct NavigationbarColorModifier: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 40)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationbarColorModifier()
}
