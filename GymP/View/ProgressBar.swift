//
//  ProgressBar.swift
//  GymP
//
//  Created by Elias Osarumwense on 24.07.24.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Rectangle()
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.orange)
                    .animation(.linear)
            }
            .cornerRadius(45.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("50% Progress")
                .font(.headline)
                .padding(.bottom, 10)

            ProgressBar(progress: 0.5) // 50% progress
                .frame(height: 5)         // Specific height of the progress bar
                .padding(.top, 2)         // Padding from the top
                .padding(.horizontal, 20) // Optional horizontal padding for better appearance
        }
        .padding()
    }
}
