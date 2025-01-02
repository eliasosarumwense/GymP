//
//  LogExerciseTrainingView.swift
//  GymP
//
//  Created by Elias Osarumwense on 24.06.24.
//

import SwiftUI

struct LogExerciseTrainingView: View {
    @State private var isRepsShown = false
    @State private var selectedIndex = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    let repetions = Array(0...100)
    
    var body: some View {
        VStack(spacing: 5) {
                
                Spacer()
                
                // Middle rectangles with black border and rounded corners
                ScrollView {
                    
                        VStack (alignment: .leading){
                            ForEach(0..<3) { _ in
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 40)
                                        
                                            .fill(colorScheme == .dark ? Color.white : Color.black)
                                            .frame(width: 65, height: 65)
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        RoundedRectangle(cornerRadius: 40)
                                        
                                            .fill(colorScheme == .light ? Color.white : Color.black)
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                HStack {
                                                    Button(action: {
                                                        withAnimation {
                                                            self.isRepsShown.toggle()
                                                        }}) {
                                                            Text("10")
                                                                .customFont(.medium, 15)
                                                        }
                                                    
                                                }
                                                    .padding()
                                            )
                                    }
                                    Text("X")
                                        .customFont(.regular, 15)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 40)
                                        
                                            .fill(colorScheme == .dark ? Color.white : Color.black)
                                            .frame(width: 155, height: 65)
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        RoundedRectangle(cornerRadius: 40)
                                        
                                            .fill(colorScheme == .light ? Color.white : Color.black)
                                            .frame(width: 150, height: 60)
                                            .overlay(
                                                HStack {
                                                    Button(action: {
                                                        withAnimation {
                                                            self.isRepsShown.toggle()
                                                        }}) {
                                                            Text("10")
                                                                .customFont(.medium, 15)
                                                        }
                                                    
                                                }
                                                    .padding()
                                            )
                                    }
                                    Spacer()
                                    
                            }
                        }
                        
                        
                    }
                    .padding()
                }
            
                if isRepsShown {
                    VStack {
                        Spacer()
                        
                        Picker(selection: $selectedIndex, label: Text("Select Reps")) {
                            ForEach(0 ..< 100) { index in
                                Text("\(repetions[index])").tag(index)
                            }
                            Text("Reps")
                        }
                        .pickerStyle(WheelPickerStyle())

                        
                        Spacer()
                    }

                }
                Spacer()
            }
                .navigationTitle("Exercise")
        
    }
        
}



#Preview {
    LogExerciseTrainingView()
}
