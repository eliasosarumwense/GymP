//
//  TodoInputForm.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import SwiftUI

struct TodoInputForm: View {
    // MARK: Core data variables
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var isPresented: Bool
    @State private var exercisename: String = ""
    @State private var exercisedescription: String = ""
    @State private var selectedMuscle: String?

    // Example muscles array

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Exercise name", text: $exercisename)
                } header: {
                    Text("Name")
                }
                
                Section {
                    TextField("Description", text: $exercisedescription)
                } header: {
                    Text("Description")
                }
                
                Section {
                    Picker("Select muscles", selection: $selectedMuscle) {
                        Text("None").tag(String?.none)
                        ForEach(muscles, id: \.self) { muscle in
                            Text(muscle).tag(String?.some(muscle))
                        }
                    }
                } header: {
                    Text("Muscle")
                }
            }
            .navigationTitle("New Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save the data and dismiss the sheet
                        self.saveTodo(name: exercisename, descrip: exercisedescription, muscle: selectedMuscle)
                        isPresented = false
                    }
                }
            }
        }
    }

    func saveTodo(name: String, descrip: String, muscle: String?) {
        let exercise = Exercise(context: self.viewContext)
        exercise.id = UUID()
        exercise.name = name
        exercise.descrip = descrip
        let exerciseMuscle = Muscle(context: self.viewContext)
        exerciseMuscle.id = UUID()
        exerciseMuscle.name = selectedMuscle
        //exercise.equipment = "test"
        exercise.image = "test"
        do {
            try self.viewContext.save()
            print("Exercise saved!")
        } catch {
            print("Whoops \(error.localizedDescription)")
        }
    }
}


