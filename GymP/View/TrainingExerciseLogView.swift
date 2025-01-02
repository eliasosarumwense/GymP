//
//  Test2.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import SwiftUI
import CoreData

struct TrainingExerciseLogView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    var exercise: Exercise?
    var training: Training?

    @EnvironmentObject var trainingState: TrainingState
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var selectedItem: TrainingExerciseTemplate?
    @State private var isConfigureValuePresented = false
    @State private var isConfigureTrainingPresented = false
    @State private var sortedExercises: [TrainingExerciseTemplate] = []

    @State private var isEditSetPresented: Bool = false
    @State private var isUpdateSetPresented: Bool = false
    
    @FetchRequest(sortDescriptors: []) private var logs: FetchedResults<Log>

    var body: some View {
        
            VStack {
                
                if let warmupExercises = filteredExercises(for: .warmup), warmupExercises.isEmpty {
                    if isEditSetPresented {
                        Button(action: {
                            addWarmUp()
                        }) {
                            HStack(spacing: 7) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.8))
                                Text("Add Warmup")
                                    .customFont(.medium, 16)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()

                        }
                    }
                }
                if let mainExercises = filteredExercises(for: .main), mainExercises.isEmpty {
                    Spacer()
                    
                    if isEditSetPresented {
                        Button(action: {
                            addItem()
                        }) {
                            HStack(spacing: 7) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.8))
                                Text("Add Set")
                                    .customFont(.medium, 16)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()

                        }
                    }
                    Text("No Sets added yet.")
                        .customFont(.medium, 15)
                        .foregroundColor(.gray)
                }
                exerciseList
                
                //actionButtons
                if !isEditSetPresented {
                    DemoChart(training: training, exercise: exercise)
                }
            }
        
        .onAppear {
            loadFilteredAndSortedExercises()
        }
        .navigationTitle("\(exercise?.name ?? "")")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // Uncomment if you want to add the spinning barbell icon when training is active
                // if trainingState.isTrainingActive, trainingState.activeTrainingID == training?.id {
                //     BarbellSpin()
                // }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    //appStateBarbellSpin.isPaused = true
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(colorSettings.selectedColor)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                editButton
            }
        }
        .sheet(isPresented: $isConfigureValuePresented, onDismiss: handleSheetDismiss) {
            if let selectedItem = selectedItem, let exercise = exercise, let training = training {
                TrainingLogSheet(
                    selectedItem: $selectedItem,
                    isEditSetPresented: $isEditSetPresented,
                    isUpdateSetPresented: $isUpdateSetPresented,
                    exercise: exercise,
                    training: training
                )
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(20)
            }
        }
    }
    
    private var exerciseList: some View {
            List {
                // Warmup section
                if let warmupExercises = filteredExercises(for: .warmup), !warmupExercises.isEmpty {
                    Section(content: {
                        ForEach(warmupExercises, id: \.self) { item in
                            exerciseRow(for: item)
                        }
  
                        if isEditSetPresented {
                            Button(action: {
                                addWarmUp()
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray.opacity(0.8))
                                    Text("Add Warmup")
                                        .customFont(.medium, 13)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                            }
                            .listRowBackground(Color.clear)
                            // Add Set button
                            Button(action: {
                                deleteLastWarmUp()
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 13))
                                        .foregroundColor(.red.opacity(0.5))
                                    Text("Delete Warmup")
                                        .customFont(.medium, 13)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }, header: {
                        Text("Warm Up").customFont(.medium, 10)
                    })
                }
                
                // Main section
                if let mainExercises = filteredExercises(for: .main), !mainExercises.isEmpty {
                    Section(content: {
                        ForEach(mainExercises, id: \.self) { item in
                            exerciseRow(for: item)
                        }
                        if shouldShowExtraSetButton(), !isEditSetPresented {
                            Button(action: {
                                addExtraset()
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Text("Extra Set")
                                        .customFont(.medium, 13)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                            }
                            .listRowBackground(Color.gray.opacity(0.1))
                        }
                        if isEditSetPresented {
                            // Add Set button
                            Button(action: {
                                addItem()
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray.opacity(0.8))
                                    Text("Add Set")
                                        .customFont(.medium, 13)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                            }
                            .listRowBackground(Color.gray.opacity(0.1))
                            // Delete Set button
                            Button(action: {
                                deleteLastItem()
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 13))
                                        .foregroundColor(.red.opacity(0.5))
                                    Text("Delete Set")
                                        .customFont(.medium, 13)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                            }
                            .listRowBackground(Color.gray.opacity(0.1))
                        }
                    }, header: {
                        Text("Sets").customFont(.medium, 10)
                    })
                }
            }
            .listStyle(.insetGrouped)
            .padding(.leading, 3)
            .padding(.trailing, 3)
        }

    private var addButton: some View {
            Button(action: addItem) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                    Text("Add Set")
                        .customFont(.regular, 15)
                        .foregroundColor(.green)
                }
            }
            .padding(6)
        }
    private var addButtonWarmUp: some View {
            Button(action: addWarmUp) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                    Text("Add Warmup")
                        .customFont(.regular, 15)
                        .foregroundColor(.green)
                }
            }
            .padding(6)
        }
    private var deleteButton: some View {
        Button(action: deleteLastItem) {
            HStack {
                Image(systemName: "xmark")
                    .foregroundColor(.red)
                Text("Delete Set")
                    .customFont(.regular, 15)
                    .foregroundColor(.red)
            }
        }
        .padding(6)
    }

    private var editButton: some View {
        Button(action: toggleEditSetPresented) {
            Image(systemName: isEditSetPresented ? "pencil.slash" : "pencil")
                .foregroundColor(colorSettings.selectedColor)
        }
    }

    private func exerciseRow(for item: TrainingExerciseTemplate) -> some View {
        HStack {
            Text("\(item.index)")
                .customFont(.light, 10)
                .foregroundStyle(.gray)
                .padding()
            Text("\(item.reps)")
                .customFont(.medium, 18)
            Text("x")
                .customFont(.semiBold, 15)
                .foregroundColor(colorSettings.selectedColor)
            Text("\(item.weight, specifier: "%.2f") kg")
                .customFont(.semiBold, 20)
            if item.isExtraSet {
                        Image(systemName: "plus")
                    .font(.system(size: 13))
                            .foregroundColor(.black)
                            .background(Circle().fill(Color.orange).frame(width: 16, height: 16))
                    }
            Spacer()
            VStack {
                
                let sortedLogs = (item.log?.array as? [Log] ?? [])
                    
                    .sorted { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
                    .prefix(item.isLogged ? 4 : 3)
                
                
                ForEach(sortedLogs, id: \.self) { log in
                    if log.trainingInstance?.id != trainingState.activeInstanceID {
                        HStack(spacing: 1) {
                            Text("\(log.reps)")
                                .customFont(.medium, 10)
                            Text("x")
                                .customFont(.medium, 10)
                            Text("\(log.weight, specifier: "%.2f") kg")
                                .customFont(.medium, 10)
                            Text(" ")
                            Text(formatDateToDateOnly(date: log.date ?? Date()))
                                .customFont(.light, 10)
                        }
                    }
                }
            }
        }
        .listRowBackground(item.isLogged ? Color.gray.opacity(0.35) : (selectedItem == item && !isEditSetPresented ? Color.gray.opacity(0.22) : Color.gray.opacity(0.1)))
        .cornerRadius(8)
        .onTapGesture {
            handleItemTap(for: item)
        }
    }

    private func handleItemTap(for item: TrainingExerciseTemplate) {
        if isEditSetPresented {
            selectedItem = item
            isConfigureValuePresented = true
        } else if item.isLogged {
            selectedItem = item
            isConfigureValuePresented = true
            isUpdateSetPresented = true
        }
        if trainingState.isTrainingActive, trainingState.activeTrainingID == training?.id, !isEditSetPresented {
            if item.isLogged {
                selectedItem = item
                isConfigureTrainingPresented = true
            } else {
                selectFirstNonLoggedItem()
            }
        }
    }

    private func handleSheetDismiss() {
        withAnimation {
            selectedItem = nil
            loadFilteredAndSortedExercises()
            isUpdateSetPresented = false
        }
    }

    private func toggleEditSetPresented() {
        withAnimation {
            isEditSetPresented.toggle()
        }
    }

    private func selectFirstNonLoggedItem() {
        if let firstNonLoggedItem = sortedExercises.first(where: { !$0.isLogged })
            {

                selectedItem = firstNonLoggedItem
                isConfigureValuePresented = true
            
        }
    }

    private func loadFilteredAndSortedExercises() {
        guard let exerciseName = exercise?.name else { return }
        let exercisesSet = training?.trainingTexercise as? Set<TrainingExerciseTemplate> ?? []
        sortedExercises = Array(exercisesSet)
            .filter { $0.exercise?.name == exerciseName }
            .sorted(by: { $0.index < $1.index })
    }

    private func filteredExercises(for section: ExerciseSection) -> [TrainingExerciseTemplate]? {
        switch section {
        case .warmup:
            return sortedExercises.filter { $0.isWarmup }
        case .main:
            return sortedExercises.filter { !$0.isWarmup }
            
        }
    }
    
    private func shouldShowExtraSetButton() -> Bool {
        return filteredExercises(for: .main)?.allSatisfy { $0.isLogged } ?? false
    }

    private enum ExerciseSection {
        case warmup
        case main
    }

    private func addItem() {
        withAnimation {
            let newItem = TrainingExerciseTemplate(context: viewContext)
            newItem.id = UUID()
            newItem.reps = 10
            newItem.weight = 10.0

            if let trainingTexercises = training?.trainingTexercise?.allObjects as? [TrainingExerciseTemplate] {
                newItem.index = Int16((trainingTexercises.filter { $0.exercise == exercise && $0.isWarmup == false }.count) + 1)
            }
            newItem.isWarmup = false
            if let exercise = exercise {
                newItem.exercise = exercise
                training?.addToTrainingTexercise(newItem)
                loadFilteredAndSortedExercises()
            }
            saveContext()
        }
    }
    
    private func addExtraset() {
        withAnimation {
            let newItem = TrainingExerciseTemplate(context: viewContext)
            newItem.id = UUID()

            // Get the last item's weight and reps
            if let lastItem = sortedExercises.filter({ !$0.isWarmup }).last {
                newItem.reps = lastItem.reps
                newItem.weight = lastItem.weight
            } else {
                newItem.reps = 10
                newItem.weight = 10.0
            }

            newItem.isExtraSet = true

            if let trainingTexercises = training?.trainingTexercise?.allObjects as? [TrainingExerciseTemplate] {
                newItem.index = Int16((trainingTexercises.filter { $0.exercise == exercise && $0.isWarmup == false }.count) + 1)
            }
            newItem.isWarmup = false
            if let exercise = exercise {
                newItem.exercise = exercise
                training?.addToTrainingTexercise(newItem)
                loadFilteredAndSortedExercises()
            }
            saveContext()

            // Handle the item tap for the new extra set item
            handleItemTap(for: newItem)
        }
    }

    
    private func addWarmUp() {
        withAnimation {
            let newItem = TrainingExerciseTemplate(context: viewContext)
            newItem.id = UUID()
            newItem.reps = 10
            newItem.weight = 10.0
            newItem.isExtraSet = false

            /*if let trainingTexercises = training?.trainingTexercise?.allObjects as? [TrainingExerciseTemplate] {
                newItem.index = Int16((trainingTexercises.filter { $0.exercise == exercise }.count) + 1)
            }*/
            newItem.isWarmup = true
            if let exercise = exercise {
                newItem.exercise = exercise
                training?.addToTrainingTexercise(newItem)
                loadFilteredAndSortedExercises()
            }
            saveContext()
        }
    }

    private func deleteLastItem() {
        withAnimation {
            guard let exerciseName = exercise?.name else { return }
            let exercisesSet = training?.trainingTexercise as? Set<TrainingExerciseTemplate> ?? []
            var filteredExercises = Array(exercisesSet)
                .filter { $0.exercise?.name == exerciseName }
                .sorted(by: { $0.index < $1.index })
            
            if let lastItem = filteredExercises.popLast() {
                viewContext.delete(lastItem)
                saveContext()
            }
        }
    }
    
    private func deleteLastWarmUp() {
        withAnimation {
            guard let exerciseName = exercise?.name else { return }
            let exercisesSet = training?.trainingTexercise as? Set<TrainingExerciseTemplate> ?? []
            var filteredExercises = Array(exercisesSet)
                .filter { $0.exercise?.name == exerciseName && $0.isWarmup}
                .sorted(by: { $0.index < $1.index })
            
            if let lastItem = filteredExercises.popLast() {
                viewContext.delete(lastItem)
                saveContext()
            }
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
            loadFilteredAndSortedExercises()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

