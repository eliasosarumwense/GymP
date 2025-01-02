//
//  ExercisesView.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import SwiftUI
import CoreData

struct ExercisesView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    var training: Training
    
    @Environment(\.presentationMode) var presentationMode
    @State var searchKeyword: String = ""
    @State var isSheetPresented: Bool = false
    // MARK: Core Data
    @FetchRequest(sortDescriptors: []) private var exercises: FetchedResults<Exercise>
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var selectedMuscle: String = "Chest"
    @State var showNotificationIfExerciseAdded = false
    
    @State private var isAnimating = false
    
    var body: some View {

            VStack (alignment: .leading){
                    Picker("Select muscle group", selection: $selectedMuscle) {
                        Text("Chest").tag("Chest")
                            .foregroundColor(colorSettings.selectedColor)
                            .font(.custom("CustomFontName", size: 13))
                        Text("Back").tag("Back")
                            .foregroundColor(colorSettings.selectedColor)
                            .font(.custom("CustomFontName", size: 13))
                        Text("Biceps").tag("Biceps")
                            .foregroundColor(colorSettings.selectedColor)
                            .font(.custom("CustomFontName", size: 13))
                        Text("Triceps").tag("Triceps")
                            .foregroundColor(colorSettings.selectedColor)
                            .font(.custom("CustomFontName", size: 13))
                        Text("Legs").tag("Legs")
                            .foregroundColor(colorSettings.selectedColor)
                            .font(.custom("CustomFontName", size: 13))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.leading)
                    .padding(.top)
            
                    List {
                        ForEach(getMusclesForSelectedGroup(), id: \.self) { muscleName in
                            let muscleExercises = filteredExercises(for: muscleName)
                            
                            Section(header: Text(muscleName)
                                .customFont(.semiBold, 25)
                                .foregroundColor(colorSettings.selectedColor)) {
                                    ForEach(muscleExercises, id: \.self) { exercise in
                                        if exercise.name != nil {
                                            ExerciseItemView(exercise: exercise, training: training, showNotificationIfExerciseAddedDummy: $showNotificationIfExerciseAdded)
                                        }
                                    }
                                }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.inset)
                    .padding(.leading)
                    .padding(.trailing)

                
                }
            .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAnimating = true
                        }
                    }
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: searchKeyword) { newValue in
                    // MARK: Core Data Operations
                    self.exercises.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS %@", newValue)
                }
                .padding(.top, 115)
                .padding(.bottom, 110)
                
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Exercises")
                            .customFont(.bold, 25)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isSheetPresented = true
                        }) {
                            Image(systemName: "plus") // Adjust the size as needed
                                .foregroundColor(colorSettings.selectedColor)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            let defaults = UserDefaults.standard
                            defaults.removeObject(forKey: "DataLoaded")
                            deleteAllExercises()
                        }) {
                            Image(systemName: "trash") // Adjust the size as needed
                                .foregroundColor(colorSettings.selectedColor)
                        }
                    }
                }
            
            
            .sheet(isPresented: $isSheetPresented, content: {
                TodoInputForm(isPresented: $isSheetPresented)
            })
            .onAppear {
                
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "DataLoaded")
                let dataLoaded = defaults.bool(forKey: "DataLoaded")
                
                if defaults.object(forKey: "DataLoaded") == nil {
                    // Set initial value to false if key doesn't exist
                    defaults.set(false, forKey: "DataLoaded")
                }
                
                if !dataLoaded {
                    // Data has not been loaded, so proceed to load it
                    defaults.set(true, forKey: "DataLoaded")
                    
                    // Perform data loading using DataManager
                    //manager.preloadExercises()
                }
            }
    }
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let todo = exercises[index]
            // MARK: Core Data Operations
            self.viewContext.delete(todo)

            do {
                try viewContext.save()
                print("perform delete")
            } catch {
                // handle the Core Data error
            }
        }
    }
    
    private func deleteAllExercises() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Exercise")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
        } catch {
            // Handle the error appropriately
            print("Error deleting all entries: \(error)")
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

struct ExerciseItemView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    let exercise: Exercise
    var training: Training
    @Binding var showNotificationIfExerciseAddedDummy: Bool
    
    var body: some View {
        NavigationLink(destination: DetailExerciseView(exercise: exercise, training: training, isTrainingDelivered: false, showNotificationIfExerciseAdded: $showNotificationIfExerciseAddedDummy)) {
            VStack(alignment: .leading) {
                HStack {
                    VStack (alignment: .leading) {
                        HStack {
                            Text(exercise.name ?? "")
                                .customFont(.medium, 20)
                                .multilineTextAlignment(.leading)
    
                        }
                    if let muscleSet = exercise.muscle, let musclesArray = muscleSet.array as? [Muscle] {
                        HStack {
                            let muscleNames = musclesArray.enumerated().compactMap { (index, muscle) -> Text? in
                                if let name = muscle.name {
                                    let text = Text(name)
                                        .customFont(.regular, 13)
                                        .foregroundColor(muscle.intensity == "main" ? colorSettings.selectedColor : .primary)
                                    return index < musclesArray.count - 1 ? text + Text(",").customFont(.regular, 13) : text
                                }
                                return nil
                            }
                            
                            ForEach(0..<muscleNames.count, id: \.self) { index in
                                muscleNames[index]
                            }
                            
                            Spacer()
                        }
                    }
                }
                    Spacer()
            }
            }
        }
    }
}

struct ExerciseTrainingItemView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    let exercise: Exercise
    var training: Training
    @Binding var showNotificationIfExerciseAdded: Bool
    
    var body: some View {
        NavigationLink(destination: DetailExerciseView(exercise: exercise, training: training, isTrainingDelivered: true, showNotificationIfExerciseAdded: $showNotificationIfExerciseAdded)) {
            VStack(alignment: .leading) {
                HStack {
                    Text(exercise.name ?? "")
                        .customFont(.medium, 20)
                        .multilineTextAlignment(.leading)
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(colorSettings.selectedColor)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}



