//
//  TrainingDetailView.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.06.24.
//

import SwiftUI
import CoreData

struct TrainingDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var colorSettings: ColorSettings
    @ObservedObject var training: Training
    @State var isSheetPresented: Bool = false
    @State var isExercisesFromTrainingDeleted = false
    @State var isShowTrainingInstancesPresented: Bool = false
    @State private var showingDeleteAlert = false
    @State private var showTrainingInstances = false // New state variable for navigation

    @EnvironmentObject var trainingState: TrainingState
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.editMode) var editMode // Tracks the edit mode
    
    @Namespace private var animationNamespace // Create the namespace for the matched geometry effect
        @State private var isDetailViewActive = false
    
    @State private var isExpanded: Bool = false
    
    @State private var isEditTrainingPresented: Bool = false
    
    @State private var trainingName: String = ""
    @State private var trainingNote: String = ""
    
    @State private var isAnimating = false

    var body: some View {
        VStack {
            if let exercises = training.exerciseT?.allObjects as? [Exercise] {
                // Sort the exercises by index in ascending order
                let sortedExercises = exercises.sorted { $0.index < $1.index }
                
                if sortedExercises.isEmpty {
                    Text("No Exercises yet")
                        .customFont(.medium, 15)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                }
                    List {
                        
                        
                        // Use a stable identifier like the exercise ID
                        ForEach(sortedExercises, id: \.id) { exercise in
                            
                            NavigationLink(destination: TrainingExerciseLogView(exercise: exercise, training: training)) {
                                HStack {
                                    Text("\(exercise.index)")
                                        .customFont(.medium, 12)
                                        .padding(2)
                                        .foregroundColor(colorSettings.selectedColor)
                                    VStack(alignment: .leading) {
                                        Text("\(exercise.name ?? "")")
                                            .customFont(.semiBold, 19)
                                            .multilineTextAlignment(.leading)
                                        if let muscleSet = exercise.muscle, let musclesArray = muscleSet.array as? [Muscle] {
                                            HStack(spacing: 4) {
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
                                            Text("\(GetCountOfExerciseSets(exercise: exercise)) Sets")
                                                .customFont(.regular, 13)
                                        }
                                        if trainingState.isTrainingActive, trainingState.activeTrainingID == training.id {
                                            ProgressBar(progress: calculateProgress(exercise: exercise))
                                                .frame(height: 5)
                                        }
                                    }
                                    Spacer()
                                    if calculateProgress(exercise: exercise) == 1.0 {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(2)
                                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                            }
                            
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                    .listStyle(.insetGrouped)
                
            }
            
            VStack (alignment: .leading) {
                Text("Notes").textCase(.uppercase)
                    .font(.customFont(.medium, 10))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                HStack {
                    Section {
                        HStack {
                            VStack(alignment: .leading) {
                                
                                Text(training.note?.isEmpty == false ? training.note! : "")
                                    .customFont(.medium, 12)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)
                                    .padding(.top, 5)
                                Spacer()
                            }
                            
                            Spacer()
                            
                            
                        }
                    }
                    .padding()
                    
                    .frame(height: isExpanded ? 190 : 40)  // Toggle height between 70 and 150
                    .background(colorScheme == .dark ? Color(.darkGray).opacity(0.2) : Color(.gray).opacity(0.2))
                    .cornerRadius(15)
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()  // Toggle the expanded state with animation
                        }
                    }
                    VStack {
                        Menu {
                            if (!trainingState.isTrainingActive) {
                                Button(action: {
                                    trainingState.activeTrainingID = training.id
                                    trainingState.isTrainingActive.toggle()
                                    trainingState.activeTrainingName = training.name
                                    saveTrainingInstance()
                                }) {
                                    Label("Start Training", systemImage: "play.fill")
                                }
                            } else if trainingState.isTrainingActive, trainingState.activeTrainingID == training.id {
                                Button(action: {
                                    stopTraining()
                                    trainingState.deleteState()
                                }) {
                                    Label("Stop Training", systemImage: "stop.fill")
                                }
                            }
                            if trainingState.isTrainingActive, trainingState.activeTrainingID != training.id {
                                Button(action: {
                                    print("Action 2")
                                }) {
                                    Label("Start Training", systemImage: "play.fill")
                                }
                                .disabled(true)
                            }
                            Button(action: {
                                showTrainingInstances = true // Trigger navigation
                            }) {
                                Label("Training Sessions", systemImage: "note.text")
                            }
                            Button(action: {
                                        isEditTrainingPresented = true
                                    }) {
                                        Label("Edit Training", systemImage: "pencil")
                                            .foregroundColor(colorSettings.selectedColor)
                                    }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(colorSettings.selectedColor)
                                .font(.system(size: 25))
                        }
                    }
                    .padding(5)
                    /*.sheet(isPresented: $isEditTrainingPresented) {
                        EditTrainingView(training: training)
                    }*/
                }
                .frame(maxWidth: 370)
                
            }
            .padding(.bottom, 10)
            //.listSectionSpacing(7)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        withAnimation {
                            if editMode?.wrappedValue == .active {
                                editMode?.wrappedValue = .inactive
                            } else {
                                editMode?.wrappedValue = .active
                            }
                        }
                    }) {
                        Image(systemName: editMode?.wrappedValue == .active ? "pencil.slash" : "pencil")
                        
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isEditTrainingPresented {
                            isEditTrainingPresented = false
                        } else {
                            //isEditTrainingPresented = true
                            isSheetPresented = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(colorSettings.selectedColor)
                    }
                }
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    BackButton(action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text("\(training.name ?? "")")
                        .customFont(.semiBold, 15)
                }
            }
            .sheet(isPresented: $isSheetPresented, content: {
                PickExercisesForTrainingView(training: training, isSheetPresented: $isSheetPresented)
                    .presentationBackgroundInteraction(.enabled) // Allows interaction with background
                                    .presentationCornerRadius(30)
            })
            .sheet(isPresented: $isEditTrainingPresented, content: {
                EditTrainingView(training: training)
                    .presentationBackgroundInteraction(.enabled) // Allows interaction with background
                    .presentationCornerRadius(30)
            })
            .background(
                NavigationLink(destination: TrainingInstancesView(training: training), isActive: $showTrainingInstances) {
                    EmptyView()
                }
            )
            if isExercisesFromTrainingDeleted {
                NotificationExerciseGotDeletedView()
                    .offset(y: -50)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: isExercisesFromTrainingDeleted)
            }
        }
        .padding(.top, -15)
        .navigationBarBackButtonHidden(true)
        

        
    }

    private func delete(at offsets: IndexSet) {
        if let exercises = training.exerciseT?.allObjects as? [Exercise] {
            let exercisesToDelete = offsets.map { exercises[$0] }
            for exercise in exercisesToDelete {
                training.removeFromExerciseT(exercise)
            }

            // Reassign indices after deletion
            let remainingExercises = training.exerciseT?.allObjects as? [Exercise] ?? []
            let sortedRemainingExercises = remainingExercises.sorted { $0.index < $1.index }

            for (newIndex, exercise) in sortedRemainingExercises.enumerated() {
                exercise.index = Int16(newIndex + 1)
            }

            // Save the context
            do {
                try viewContext.save()
                withAnimation {
                    isExercisesFromTrainingDeleted = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isExercisesFromTrainingDeleted = false
                    }
                }
                print("Exercises deleted and indices updated")
            } catch {
                print("Error deleting exercises or saving updates: \(error.localizedDescription)")
            }
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        guard var exercises = training.exerciseT?.allObjects as? [Exercise] else { return }

        // Sort and reorder the exercises
        var sortedExercises = exercises.sorted { $0.index < $1.index }
        sortedExercises.move(fromOffsets: source, toOffset: destination)

        // Update the index of each exercise after the move
        for (newIndex, exercise) in sortedExercises.enumerated() {
            exercise.index = Int16(newIndex + 1)
        }

        // Update the training's exercise set
        training.exerciseT = NSSet(array: sortedExercises)

        // Save the context with detailed error handling
        do {
            try viewContext.save()
            print("Successfully saved context")
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    private func GetCountOfExerciseSets(exercise: Exercise) -> Int {
        guard let exerciseID = exercise.id else { return 0 }
        guard let exerciseSet = training.trainingTexercise as? Set<TrainingExerciseTemplate> else { return 0 }
        var exerciseTemplateCount = 0
        for exerciseTemplate in exerciseSet {
            if let templateExerciseID = exerciseTemplate.exercise?.id, templateExerciseID == exerciseID, !exerciseTemplate.isWarmup {
                exerciseTemplateCount += 1
            }
        }
        return exerciseTemplateCount
    }

    private func calculateProgress(exercise: Exercise) -> Double {
        guard let exerciseSet = training.trainingTexercise as? Set<TrainingExerciseTemplate> else { return 0.0 }
        let exerciseTemplates = exerciseSet.filter { $0.exercise?.id == exercise.id }
        let loggedCount = exerciseTemplates.filter { $0.isLogged }.count
        return Double(loggedCount) / Double(exerciseTemplates.count)
    }

    private func saveTrainingInstance() {
        let newTrainingInstance = TrainingInstance(context: self.viewContext)
        let id = UUID()
        newTrainingInstance.date = Date()
        newTrainingInstance.trainingstart = Date()
        newTrainingInstance.training = training
        newTrainingInstance.id = id
        do {
            try self.viewContext.save()
            trainingState.activeInstanceID = id
        } catch {
            print("Error saving training instance: \(error.localizedDescription)")
        }
    }

    private func stopTraining() {
        if let activeInstanceID = trainingState.activeInstanceID,
           let activeTrainingInstance = fetchTrainingInstance(with: activeInstanceID) {
            activeTrainingInstance.trainingend = Date()
            do {
                try viewContext.save()
            } catch {
                print("Error saving training instance: \(error.localizedDescription)")
            }
        }
        trainingState.deleteState()
        updateTrainingExerciseTemplatesLoggedState(false)
    }

    private func fetchTrainingInstance(with id: UUID) -> TrainingInstance? {
        let fetchRequest: NSFetchRequest<TrainingInstance> = TrainingInstance.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let instances = try viewContext.fetch(fetchRequest)
            return instances.first
        } catch {
            print("Error fetching training instance: \(error.localizedDescription)")
            return nil
        }
    }

    private func updateTrainingExerciseTemplatesLoggedState(_ state: Bool) {
        if let trainingTemplates = training.trainingTexercise as? Set<TrainingExerciseTemplate> {
            for template in trainingTemplates {
                template.isLogged = state
            }
            do {
                try viewContext.save()
            } catch {
                print("Error updating training exercise templates: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveEditChanges() {
        training.name = trainingName
        training.note = trainingNote

        do {
            try viewContext.save()
        } catch {
            print("Failed to save training changes: \(error.localizedDescription)")
        }
    }
}
