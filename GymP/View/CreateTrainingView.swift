//
//  CreateTrainingView.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.06.24.
//

import SwiftUI

struct CreateTrainingView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var isNewTrainingPresented: Bool
    @State private var trainingName: String = ""
    @State private var trainingNote: String = ""
    @State private var selectedMuscle: String?
    @State private var showAlert = false
    
    @State var currentTrainingRoutine: TrainingRoutine?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Training Name", text: $trainingName)
                        .font(.customFont(.light, 15))
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                } header: {
                    Text("Name")
                        .customFont(.semiBold, 12)
                }
                
                Section {
                    TextEditor(text: $trainingNote)
                        .font(.customFont(.light, 15))
                        .frame(height: 200)
                        .textInputAutocapitalization(.sentences)
                        .disableAutocorrection(true)
                } header: {
                    Text("Description")
                        .customFont(.semiBold, 12)
                }
                
                // Example Picker for muscle selection if you want to use `selectedMuscle`
                Section {
                    Picker("Select Muscle Group", selection: $selectedMuscle) {
                        Text("Chest").tag("Chest")
                        Text("Back").tag("Back")
                        Text("Legs").tag("Legs")
                        Text("Arms").tag("Arms")
                    }
                } header: {
                    Text("Muscle Group")
                        .customFont(.semiBold, 12)
                }
            }
            .navigationTitle("New Training")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Training name is required"), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isNewTrainingPresented = false
                    }) {
                        Text("Cancel")
                            .customFont(.medium, 15)
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if self.trainingName.isEmpty {
                            showAlert = true
                        } else {
                            self.saveTraining(name: trainingName, note: trainingNote)
                            isNewTrainingPresented = false
                            resetForm()
                        }
                    }) {
                        Text("Save")
                            .customFont(.medium, 15)
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
            }
        }
    }
    
    // Save function remains the same
    func saveTraining(name: String, note: String) {
        let training = Training(context: self.viewContext)
        training.id = UUID()
        training.name = name
        training.note = note
        training.trainingRoutine = currentTrainingRoutine

        do {
            try self.viewContext.save()
            print("Training saved!")
        } catch {
            print("Whoops \(error.localizedDescription)")
        }
    }
    
    // Reset form after saving
    func resetForm() {
        trainingName = ""
        trainingNote = ""
        selectedMuscle = nil
    }
}

