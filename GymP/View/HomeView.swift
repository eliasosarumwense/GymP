//
//  HomeView.swift
//  GymP
//
//  Created by Elias Osarumwense on 11.08.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @State private var isAnimating = false
    var body: some View {
        VStack {
            Text("Hello, World!")
                .foregroundColor(colorSettings.selectedColor)
                .padding()

            Spacer()
            
            // Rounded Rectangle Button
            NavigationLink(destination: CalculateWeightOnEachSideView()) {
                Text("Calculate Weight")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(colorSettings.selectedColor))
                    .shadow(radius: 5)
            }
            .padding()

            /*NavigationLink(destination: CustomCompactDatePickerView()) {
                Text("Calender")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(colorSettings.selectedColor))
                    .shadow(radius: 5)
            }
            .padding()
            */
            Spacer()
        }
        .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isAnimating = true
                    }
                }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Home")
                    .customFont(.bold, 25)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .foregroundColor(colorSettings.selectedColor)
                }
            }
        }
    }
}


