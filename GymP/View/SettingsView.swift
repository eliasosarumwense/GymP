//
//  SettingsView.swift
//  GymP
//
//  Created by Elias Osarumwense on 11.08.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
            VStack {
                // Other settings options can go here
                
                NavigationLink(destination: AppColorPickerView()) {
                    HStack {
                        Text("Choose App Color")
                            .customFont(.medium, 15)
                            .padding()
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Circle()
                            .fill(colorSettings.selectedColor)
                            .frame(width: 24, height: 24)
                    }
                    .padding()
                    .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
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
    SettingsView()
}
