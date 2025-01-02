//
//  BackButton.swift
//  GymP
//
//  Created by Elias Osarumwense on 30.08.24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.colorScheme) var colorScheme
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isPressed = false
                        }
                    }
                    action()
                }) {
            Text("Back")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .customFont(.medium, 12)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(colorScheme == .dark ? Color.darkGray : .white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.gray.opacity(0.1), radius: 3, x: 0, y: 2)
        }
    }
}

/*struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BackButton()
                .previewDisplayName("Light Mode")
            
            BackButton()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}*/

// Define a custom dark gray color
extension Color {
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
}
