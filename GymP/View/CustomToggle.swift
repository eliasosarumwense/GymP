//
//  OrangeToggleStyle.swift
//  GymP
//
//  Created by Elias Osarumwense on 02.08.24.
//

import SwiftUI

struct CustomToggle: ToggleStyle {
    @EnvironmentObject var colorSettings: ColorSettings
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Rectangle()
                .fill(configuration.isOn ? colorSettings.selectedColor : Color.gray)
                .frame(width: 40, height: 20)  // Adjust the width and height to make the toggle smaller
                .cornerRadius(10)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 2)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)  // Adjust the offset as needed
                )
                .onTapGesture {
                    withAnimation {
                        configuration.isOn.toggle()
                    }
                }
        }
        .padding(.horizontal, 10)  // Adjust padding as needed
    }
}
