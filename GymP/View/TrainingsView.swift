//
//  TrainingsView.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.06.24.
//

import SwiftUI
import CoreData

struct TrainingsView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.colorScheme) var colorScheme
    @Namespace var animation
    @Environment(\.presentationMode) var presentationMode
    @State var searchKeyword: String = ""
    @State var isNewTrainingPresented: Bool = false
    @State var isExerciseDeleted = false
    
    @State private var isAnimating = false
    
    // MARK: Core Data
    @FetchRequest(sortDescriptors: []) private var trainings: FetchedResults<Training>
    
    @EnvironmentObject var manager: DataManager
    @EnvironmentObject var trainingState: TrainingState
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var isSelectTrainingRoutine = false
    
    @State private var selectedTrainingRoutine: TrainingRoutine? {
        didSet {
            // Save the selected routine ID to UserDefaults
            saveSelectedRoutineID(selectedTrainingRoutine?.id)
        }
    }
    
    @State private var routineToChange: Training?
        @State private var isChangeRoutinePresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            List {
                Section {
                    HStack {
                        
                        Text("\(selectedTrainingRoutine?.name ?? "Exercises with no Routine")")
                            .customFont(.semiBold, 17)
                        Spacer()
                        NavBarButton(buttonText: "New Training", action: {
                            isNewTrainingPresented = true
                        })
                    }
                    .padding(.vertical, 5)
                    .cornerRadius(30)
                }
                .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
                
                    if selectedTrainingRoutine?.training?.count == 0 {
                        HStack {
                            Spacer()
                            Text("No Trainings yet")
                                .customFont(.medium, 15)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                
                Section {
                    ForEach(trainings, id: \.self) { training in
                        if training.trainingRoutine == selectedTrainingRoutine {
                            NavigationLink(destination: TrainingDetailView(training: training)) {
                                VStack(alignment: .leading) {
                                    Text("\(training.name ?? "")")
                                        .customFont(.bold, 20)
                                    
                                    // Display the number of exercises
                                    Text(exerciseText(for: training.exerciseCount))
                                        .customFont(.regular, 13)
                                        .foregroundColor(colorSettings.selectedColor)
                                    //.foregroundColor(.orange)
                                    
                                    // Conditionally display the progress bar
                                    if trainingState.isTrainingActive, training.id == trainingState.activeTrainingID {
                                        ProgressBar(progress: calculateTrainingProgress(training: training))
                                            .frame(height: 5)
                                            .padding(.top, 2)
                                    }
                                    
                                    // Display the last training instance date
                                    if let lastDate = training.lastTrainingDate {
                                        Text("\(timeElapsedString(from: lastDate)) ago")
                                            .customFont(.regular, 12)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("-")
                                            .customFont(.regular, 8)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .contextMenu {
                                Button(action: {
                                    routineToChange = training
                                    isChangeRoutinePresented = true
                                }) {
                                    Text("Change Routine")
                                    Image(systemName: "arrow.right.arrow.left.circle")
                                }
                                Button(action: {
                                    routineToChange = training
                                    setRoutineToNil()
                                }) {
                                    Text("No Routine")
                                    Image(systemName: "nosign")
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
            }
            
        
            }
            .onAppear {
                // Load the selected routine from UserDefaults when the view appears
                if let routineID = loadSelectedRoutineID() {
                    selectedTrainingRoutine = fetchRoutine(by: routineID, context: viewContext)
                } else {
                    selectedTrainingRoutine = nil
                }
            }
            .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAnimating = true
                        }
                    }
            .padding(.top, 85)
            .padding(.bottom, 110)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Trainings")
                        .customFont(.bold, 25)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavBarButton(buttonText: "Change Routine", action: {
                        isSelectTrainingRoutine = true
                    })
                    /*
                    Button(action: {
                        isNewTrainingPresented = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(colorSettings.selectedColor)
                    }
                     */
                }
            }
        
        .onChange(of: searchKeyword) { newValue in
            self.trainings.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS %@", newValue)
        }
        .sheet(isPresented: $isNewTrainingPresented, content: {
            CreateTrainingView(isNewTrainingPresented: $isNewTrainingPresented, currentTrainingRoutine: selectedTrainingRoutine)
                .presentationCornerRadius(30)
                .matchedGeometryEffect(id: "animation", in: animation)
        })
        .sheet(isPresented: $isSelectTrainingRoutine, content: {
            ManageTrainingRoutineView(selectedTrainingRoutine: $selectedTrainingRoutine)
                .presentationCornerRadius(30)

                .presentationDetents([.height(350)])
                .presentationDragIndicator(.hidden)
        })
        .sheet(isPresented: $isChangeRoutinePresented, content: {
            ChangeRoutineView(training: $routineToChange)
                .presentationCornerRadius(30)
                .presentationDetents([.height(350)])
                .presentationDragIndicator(.hidden)
        })
        
        
    }
    
    private func exerciseText(for count: Int) -> String {
        switch count {
        case 0:
            return "no exercises"
        case 1:
            return "1 Exercise"
        default:
            return "\(count) Exercises"
        }
    }
    
    private func timeElapsedString(from date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: now)
        
        var timeString = ""
        
        if let days = components.day, days > 0 {
            timeString += "\(days) day\(days > 1 ? "s" : "") "
        }
        
        if let hours = components.hour, hours > 0 {
            timeString += "\(hours) hour\(hours != 1 ? "s" : "")"
        }
        
        if let days = components.day, days == 0, let minutes = components.minute {
            timeString += " \(minutes) minute\(minutes != 1 ? "s" : "")"
        }
        
        return timeString.trimmingCharacters(in: .whitespaces)
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let training = trainings[index]
            // MARK: Core Data Operations
            self.viewContext.delete(training)

            isExerciseDeleted = true
            do {
                try viewContext.save()
                print("perform delete")
            } catch {
                // handle the Core Data error
            }
        }
    }
    
    func setRoutineToNil() {
            routineToChange?.trainingRoutine = nil
            saveContext()
        func saveContext() {
                do {
                    try routineToChange?.managedObjectContext?.save()
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                }
            }
        }
    
    private func calculateTrainingProgress(training: Training) -> Double {
        // Retrieve the set of exercises associated with the training
        guard let exerciseTemplates = training.trainingTexercise as? Set<TrainingExerciseTemplate> else { return 0.0 }
        
        // Filter out warm-up sets and count the total number of non-warmup templates
        let nonWarmupTemplates = exerciseTemplates.filter { !$0.isWarmup }
        let totalSets = nonWarmupTemplates.count
        
        // Count the number of logged (completed) non-warmup templates
        let loggedSets = nonWarmupTemplates.filter { $0.isLogged }.count
        
        // Calculate progress as the ratio of logged sets to total sets
        return totalSets > 0 ? Double(loggedSets) / Double(totalSets) : 0.0
    }
}

extension Training {
    
    var exerciseCount: Int {
        return exerciseT?.count ?? 0
    }
    
    var lastTrainingDate: Date? {
        let sortedInstances = (trainingInstance as? Set<TrainingInstance>)?.sorted { $0.date ?? Date.distantPast > $1.date ?? Date.distantPast }
        return sortedInstances?.first?.date
    }
}
