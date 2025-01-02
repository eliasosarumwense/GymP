//
//  ChangeTrainingView.swift
//  GymP
//
//  Created by Elias Osarumwense on 27.08.24.
//

import SwiftUI

struct EditTrainingView: View {
            
    @ObservedObject var training: Training
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var colorSettings: ColorSettings

    @State private var trainingName: String = ""
    @State private var trainingNote: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter training name", text: $trainingName)
                        .font(.customFont(.light, 15))
                        .onAppear {
                            trainingName = training.name ?? ""
                        }
                }
                header: {
                    Text("Training Name")
                        .customFont(.semiBold, 12)
                }
                

                Section{
                    TextEditor(text: $trainingNote)
                        .font(.customFont(.light, 15))
                        .onAppear {
                            trainingNote = training.note ?? ""
                        }
                }
            header: {
            
                Text("Notes")
                    .customFont(.semiBold, 12)
            
            }
            }
            .navigationBarTitle("Edit Training", displayMode: .inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .customFont(.medium, 15)
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .customFont(.medium, 15)
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
            }
        }
    }

    private func saveChanges() {
        training.name = trainingName
        training.note = trainingNote

        do {
            try viewContext.save()
        } catch {
            print("Failed to save training changes: \(error.localizedDescription)")
        }
    }
}
