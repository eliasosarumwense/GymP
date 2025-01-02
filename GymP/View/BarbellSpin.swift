//
//  BarbellSpin.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.07.24.
//

import SwiftUI
import Combine

struct BarbellSpin: View {
    @State private var rotationAngle: Double = 0
    @State private var isPaused = false

    var body: some View {
        VStack {
            Image(systemName: "dumbbell.fill")
                .font(.subheadline)
                .rotationEffect(.degrees(rotationAngle))
                .foregroundColor(.orange)
                .onAppear {
                    startSpinning()
                }
        }
    }

    private func startSpinning() {
        // Start the initial spin
        spin()
        
        // Schedule a timer to spin every 2 seconds (1 second for spinning + 1 second pause)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            if isPaused {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isPaused = false
                    spin()
                }
            } else {
                isPaused = true
            }
        }
    }

    private func spin() {
        withAnimation(Animation.easeInOut(duration: 1)) {
            rotationAngle += 720
        }
    }
}


#Preview {
    BarbellSpin()
}
