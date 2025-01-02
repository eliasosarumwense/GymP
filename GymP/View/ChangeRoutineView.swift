//
//  ChangeRoutineView.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//

import SwiftUI

struct ChangeRoutineView: View {
    
    @EnvironmentObject var colorSettings: ColorSettings
    @Binding var training: Training?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TrainingRoutine.name, ascending: true)])
    private var routines: FetchedResults<TrainingRoutine>
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(routines, id: \.self) { routine in
                HStack {
                    Text(routine.name ?? "Unnamed Routine")
                        .customFont(.medium, 15)
                        .foregroundColor(.primary)
                    Spacer()
                    if routine == training?.trainingRoutine {
                        Image(systemName: "checkmark")
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    training?.trainingRoutine = routine
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Change Routine")
                        .customFont(.semiBold, 15)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .customFont(.medium, 15)
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.down")
                            .foregroundColor(colorSettings.selectedColor)
                        
                    }
                }
            }
        }
    }
    
    func saveContext() {
        do {
            try training?.managedObjectContext?.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
