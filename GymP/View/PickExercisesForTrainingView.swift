//
//  PickExercisesForTrainingView.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.06.24.
//

import SwiftUI

struct PickExercisesForTrainingView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    var training: Training
    @Binding var isSheetPresented: Bool
    
    @State var searchKeyword: String = ""
    
    @State var showNotificationIfExerciseAdded = false

    // MARK: Core Data
    @FetchRequest(sortDescriptors: []) private var exercises: FetchedResults<Exercise>
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    @State private var selectedMuscle: String = "Chest"
    
    @State private var selectedExercises: [Exercise] = []
    var body: some View {
                
        NavigationView {
            VStack (alignment: .leading){
                Picker("Select muscle group", selection: $selectedMuscle) {
                    Text("Chest").tag("Chest")
                    
                    Text("Back").tag("Back")
                    
                    Text("Biceps").tag("Biceps")
                    
                    Text("Triceps").tag("Triceps")
                    
                    Text("Legs").tag("Legs")
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(getMusclesForSelectedGroup(), id: \.self) { muscleName in
                        let muscleExercises = filteredExercises(for: muscleName)
                        
                        Section(header: Text(muscleName)) {
                            ForEach(muscleExercises, id: \.self) { exercise in
                                if exercise.name != nil {
                                    ExerciseTrainingItemView(exercise: exercise, training: training, showNotificationIfExerciseAdded: $showNotificationIfExerciseAdded)
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
            //.navigationTitle("Pick an Exercise")
            
            .onChange(of: searchKeyword) { newValue in
                // MARK: Core Data Operations
                self.exercises.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS %@", newValue)
            }
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSheetPresented = false
                    }) {
                        Text("Cancel")
                            .customFont(.regular, 15)
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                
                /*ToolbarItem(placement: .principal) {
                    if showNotificationIfExerciseAdded {
                        NotificationExerciseGotAddedView()
                            .transition(.move(edge: .top))
                        //.offset(y: 500)
                    }
                }*/
                ToolbarItem(placement: .topBarLeading) {
                    Text("Pick an Exercise")
                        .customFont(.semiBold, 18)

                }
                
            }
        }
            
        
    }
    private func getMusclesForSelectedGroup() -> [String] {
        switch selectedMuscle {
        case "Chest":
            return ["Chest"]
        case "Back":
            return ["Lat", "Upper Back", "Trapezius", "Middle Back", "Lower Back"]
        case "Biceps":
            return ["Biceps"]
        case "Triceps":
            return ["Triceps"]
        case "Legs":
            return ["Quadriceps", "Hamstrings", "Calves", "Glutes"]
        default:
            return []
        }
    }
    
    func filteredExercises(for muscleName: String) -> [Exercise] {
        return exercises.filter { exercise in
            if let muscles = exercise.muscle?.array as? [Muscle] {
                return muscles.contains { $0.name == muscleName }
            }
            return false
        }
    }
}

struct NotificationExerciseGotAddedView: View {
    var body: some View {
        VStack {
            HStack (spacing: 1){
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Exercise Added!")
                    .customFont(.bold, 12)
            }
            .offset(x: -30)
            //.padding(.trailing, 20)
            .frame(maxWidth: .infinity)
            //.background(Color.gray)
            .cornerRadius(10)
            //.padding()
            //Spacer()
        }
    }
}

struct NotificationExerciseGotDeletedView: View {
    var body: some View {
        VStack {
            HStack (spacing: 1){
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
                Text("Exercise deleted!")
                    .customFont(.bold, 16)
            }
            //.offset(y: 30)
            //.padding(.trailing, 20)
            //.frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut, value: UUID())
        }
    }
}

