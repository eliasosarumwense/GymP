//
//  ConfigureExerciseTemplateItemSheet.swift
//  GymP
//
//  Created by Elias Osarumwense on 13.07.24.
//

import SwiftUI
import CoreData

struct TrainingLogSheet: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var selectedItem: TrainingExerciseTemplate?
    @Binding private var isEditSetPresented: Bool
    @Binding private var isUpdateSetPresented: Bool
    
    @State private var reps: Int
    @State private var weightBeforeSemicolon: Int
    @State private var weightAfterSemicolon: Int
    
    var exercise: Exercise
    var training: Training

    @EnvironmentObject var trainingState: TrainingState

    init(selectedItem: Binding<TrainingExerciseTemplate?>, isEditSetPresented: Binding<Bool>, isUpdateSetPresented: Binding<Bool>, exercise: Exercise, training: Training) {
        _selectedItem = selectedItem
        _reps = State(initialValue: Int(selectedItem.wrappedValue?.reps ?? 0))
        _isEditSetPresented = isEditSetPresented
        _isUpdateSetPresented = isUpdateSetPresented
        
        // Parse weight into before and after semicolon parts
        let weightString = String(selectedItem.wrappedValue?.weight ?? 0.0)
        let weightComponents = weightString.components(separatedBy: ".")
        _weightBeforeSemicolon = State(initialValue: Int(weightComponents.first ?? "0") ?? 0)
        _weightAfterSemicolon = State(initialValue: Int(weightComponents.last ?? "0") ?? 0)
        
        self.exercise = exercise
        self.training = training
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedItem = nil
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(colorSettings.selectedColor)
                        .font(.system(size: 22))
                }
                Spacer()
                if isEditSetPresented {
                    Text("Edit Set")
                        .customFont(.semiBold, 15)
                        .foregroundColor(colorSettings.selectedColor)
                }
                else if isUpdateSetPresented {
                    Text("Update Set")
                        .customFont(.semiBold, 15)
                        .foregroundColor(colorSettings.selectedColor)
                }
                else {
                    Text("Log Set")
                        .customFont(.semiBold, 15)
                        .foregroundColor(colorSettings.selectedColor)
                }
                Spacer()
                if isUpdateSetPresented {
                    Button(action: deleteLog) {
                        Text("Delete")
                            .customFont(.semiBold, 15)
                            .foregroundColor(.red)
                            .background(Color.clear)
                            .cornerRadius(10)
                    }
                }
                Button(action: saveChanges) {
                    Text("Save")
                        .customFont(.semiBold, 15)
                        .foregroundColor(colorSettings.selectedColor)
                        .background(Color.clear)
                        .cornerRadius(10)
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .offset(y: -10)
            HStack {
                Text("x")
                    .foregroundColor(.primary)
                    .customFont(.medium, 15)
                    .offset(x: -35)
                Text(",")
                    .customFont(.medium, 15)
                    .offset(x: 40)
                Text("kg")
                    .customFont(.medium, 15)
                    .offset(x: 120)
            }
            .offset(y: 90)
            HStack {
                Picker("Reps", selection: $reps) {
                    ForEach(1 ..< 100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 120, height: 150)
                .clipShape(Rectangle().offset(x: -16))
                .offset(x: 30)
                
                Text("x")
                    .customFont(.medium, 15)
                    .foregroundColor(colorSettings.selectedColor)
                    .offset(x: 15)
                    
                Picker("Weight", selection: $weightBeforeSemicolon) {
                    ForEach(0 ..< 1000, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 140, height: 150)
                .clipShape(Rectangle().offset(x: 16))
                .clipShape(Rectangle().offset(x: -16))
                .offset(x: -18)
                
                Text(",")
                    .customFont(.medium, 15)
                
                Picker("", selection: $weightAfterSemicolon) {
                    Text("00").tag(0)
                    Text("25").tag(25)
                    Text("50").tag(50)
                    Text("75").tag(75)
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80, height: 150)
                .clipShape(Rectangle().offset(x: 16))
                .offset(x: -66)
                
                Text("kg")
                    .customFont(.medium, 15)
            }
        }
        .padding()
    }

    private func saveChanges() {
        // Combine selected weight parts into a single Double value
        let combinedWeight = Double(weightBeforeSemicolon) + Double(weightAfterSemicolon) / 100.0
        
        selectedItem?.reps = Int32(reps)
        selectedItem?.weight = combinedWeight
        
        
        // Save changes to CoreData context
        do {
            if isEditSetPresented {
                // Update the selectedItem with new reps and weight
                  // Set isLogged to true
                try selectedItem?.managedObjectContext?.save()
                selectedItem = nil
            } else if isUpdateSetPresented {
                
                //selectedItem?.isLogged = true
                // Fetch the existing log associated with the selectedItem and update it
                if let log = fetchLog(for: selectedItem) {
                    log.reps = Int32(reps)
                    log.weight = combinedWeight
                    try viewContext.save()
                }
                isUpdateSetPresented = false
            } else {
                
                selectedItem?.isLogged = true
                // Fetch the active TrainingInstance
                if let activeInstanceID = trainingState.activeInstanceID,
                   let activeTrainingInstance = fetchTrainingInstance(by: activeInstanceID) {
                    let newLog = Log(context: self.viewContext)
                    let LogID = UUID()
                    newLog.id = LogID
                    newLog.date = Date()
                    newLog.reps = Int32(reps)
                    newLog.weight = combinedWeight
                    newLog.exercise = exercise
                    newLog.training = training
                    newLog.trainingInstance = activeTrainingInstance
                    newLog.trainingTemplate = selectedItem
                    selectedItem?.temporarLogID = LogID
                    activeTrainingInstance.addToLog(newLog)
                    try viewContext.save()
                }
            }
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func fetchLog(for template: TrainingExerciseTemplate?) -> Log? {
        guard let template = template, let id = template.temporarLogID else { return nil }
        let request: NSFetchRequest<Log> = Log.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            print("Error fetching Log: \(error.localizedDescription)")
            return nil
        }
    }

    private func fetchTrainingInstance(by id: UUID) -> TrainingInstance? {
        let request: NSFetchRequest<TrainingInstance> = TrainingInstance.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            print("Error fetching TrainingInstance: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func deleteLog() {
        selectedItem?.isLogged = false
        if let log = fetchLog(for: selectedItem) {
            viewContext.delete(log)
            do {
                try viewContext.save()
                
                isUpdateSetPresented = false
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error deleting log: \(error.localizedDescription)")
            }
        }
    }
}
