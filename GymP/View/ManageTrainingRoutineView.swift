//
//  ManageTrainingRoutineView.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//

import SwiftUI

struct ManageTrainingRoutineView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TrainingRoutine.name, ascending: true)])
    private var routines: FetchedResults<TrainingRoutine>
    
    @FetchRequest(
        entity: Training.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "trainingRoutine == nil")
    )
    private var trainingsWithNoRoutine: FetchedResults<Training>

    @Binding var selectedTrainingRoutine: TrainingRoutine?
    {
        didSet {
            // Save the selected routine ID to UserDefaults
            saveSelectedRoutineID(selectedTrainingRoutine?.id)
        }
    }
    @Environment(\.presentationMode) var presentationMode
    
    @State var isCreateRoutinePresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Option for "Training with no Routine"
                    HStack {
                        if selectedTrainingRoutine == nil {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(colorSettings.selectedColor)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                        
                        Text("Training with no Routine")
                            .customFont(.medium, 15)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedTrainingRoutine = nil
                                }
                            }
                        
                        Spacer()
                        
                        Text("\(trainingsWithNoRoutine.count) \(trainingsWithNoRoutine.count == 1 ? "Training" : "Trainings")")
                            .foregroundColor(.secondary)
                            .customFont(.medium, 12)
                    }
                    .padding(5)
                    // List of routines
                    ForEach(routines, id: \.self) { routine in
                        HStack {
                            if selectedTrainingRoutine == routine {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(colorSettings.selectedColor)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                            
                            Text(routine.name ?? "Unnamed Routine")
                                .customFont(.medium, 15)
                            
                            Spacer()
                            
                            Text("\(routine.training?.count ?? 0) \(routine.training?.count == 1 ? "Training" : "Trainings")")
                                .foregroundColor(.secondary)
                                .customFont(.medium, 12)
                        }
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedTrainingRoutine = routine
                            }
                        }
                        
                    }
                }
                
                Spacer()
            }

            .padding()
            .navigationBarTitle("Manage Training Routines", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.down")
                            .foregroundColor(colorSettings.selectedColor)
                        
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Your Training Routines")
                        .customFont(.semiBold, 15)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreateRoutinePresented = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                
            }
            .sheet(isPresented: $isCreateRoutinePresented, content: {
                CreateTrainingRoutine()
            })
        }
    }
}
