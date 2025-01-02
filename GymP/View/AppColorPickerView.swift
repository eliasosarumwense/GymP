//
//  AppColorPickerView.swift
//  GymP
//
//  Created by Elias Osarumwense on 11.08.24.
//

import SwiftUI

struct AppColorPickerView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let predefinedColors: [Color] = [.orange, .red, .green, .blue, .gray, .yellow]
    let colorNames: [String] = ["Orange", "Red", "Green", "Blue", "Gray", "Yellow"]
    
    var body: some View {
        VStack {
            // Predefined Colors
            ForEach(0..<predefinedColors.count, id: \.self) { index in
                Button(action: {
                    colorSettings.selectedColor = predefinedColors[index]
                }) {
                    HStack {
                        Text(colorNames[index])
                            .foregroundColor(colorSettings.selectedColor == predefinedColors[index] ? colorSettings.selectedColor : .primary)
                            .customFont(.medium, 18)
                        Spacer()
                        Circle()
                            .fill(predefinedColors[index])
                            .frame(width: 24, height: 24)
                        
                        
                    }
                    .padding()
                    .background(colorSettings.selectedColor == predefinedColors[index] ? Color.secondary.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                }
            }
            
            Divider().padding(.vertical)
            
            // Custom Color Picker
            HStack {
                Text("Select Custom Color")
                    .customFont(.medium, 18)
                Spacer()
                ColorPicker("", selection: $colorSettings.selectedColor)
                    .labelsHidden()
                    .frame(maxWidth: 50) // Adjust width as needed
            }

            .padding(2)
            
            Spacer()
        }
        .padding(2)
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    //appStateBarbellSpin.isPaused = true
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(colorSettings.selectedColor)
                }
            }
        }
    }
}

#Preview {
    AppColorPickerView()
}
