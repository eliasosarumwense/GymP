//
//  CreateTrainingRoutine.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//

import SwiftUI

struct CreateTrainingRoutine: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var routineName: String = ""
    @State private var routineNotes: String = ""
    
    // Assuming you have a managedObjectContext from the environment for saving the new routine
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine Details")) {
                    TextField("Name", text: $routineName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Notes", text: $routineNotes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationTitle("Create Routine")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            saveRoutine()
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(routineName.isEmpty)
    }
    
    private func saveRoutine() {
        let newRoutine = TrainingRoutine(context: viewContext)
        newRoutine.id = UUID()
        newRoutine.name = routineName
        newRoutine.notes = routineNotes
        
        do {
            try viewContext.save()
        } catch {
            // Handle the Core Data error here
            print("Failed to save routine: \(error.localizedDescription)")
        }
    }
}
#Preview {
    CreateTrainingRoutine()
}
