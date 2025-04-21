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
    @State var isScheduleRoutineSelected: Bool = false
    @State var isExerciseDeleted = false
    
    @State private var isAnimating = false
    @State private var scheduleSheetHeight: CGFloat = 635
    
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
            
            ZStack {
                List {
                    Section {
                        HStack {
                            
                            HStack(spacing: 5) {
                                // Light grey note label
                                Image(systemName: "note.text")
                                    .foregroundColor(.gray)  // Light grey color
                                    .font(.system(size: 14))  // Adjust the size as needed
                                
                                // Existing text with custom font
                                Text("\(selectedTrainingRoutine?.name ?? "Exercises with no Routine")")
                                    .customFont(.bold, 20)
                            }                        /*
                                                      Spacer()
                                                      NavBarButton(buttonText: "New Training", action: {
                                                      isNewTrainingPresented = true
                                                      })
                                                      */
                            HStack(spacing: 3) {
                                // Timer icon on the left side
                                Image(systemName: "timer")
                                    .foregroundColor(.gray)  // Adjust the color of the icon if needed
                                    .font(.system(size: 12))  // Adjust the size of the icon
                                
                                // Text displaying the last training date
                                if let getLastTrainingDate = getLastTrainingDate() {
                                    Text("\(timeElapsedString(from: getLastTrainingDate))")
                                        .customFont(.regular, 13)
                                        .foregroundStyle(.gray)
                                } else {
                                    Text("No trainings done yet.")
                                        .foregroundStyle(.gray)
                                        .customFont(.regular, 10)
                                }
                            }
                            
                        }
                        
                        .cornerRadius(30)
                    }
                    .listRowBackground(Color.darkGray)
                    
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
                                            Text("never trained")
                                                .customFont(.light, 10)
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
                        //.scrollContentBackground(.hidden)
                    }
                    .listRowBackground(Color.darkGray)
                }
                .scrollContentBackground(.hidden)
            }
            .onAppear {
                // Load the selected routine from UserDefaults when the view appears
                if let routineID = loadSelectedRoutineID() {
                    selectedTrainingRoutine = fetchRoutine(by: routineID, context: viewContext)
                } else {
                    selectedTrainingRoutine = nil
                }
                scheduleSheetHeight = 635
            }
            /*
             .opacity(isAnimating ? 1 : 0)
             .scaleEffect(isAnimating ? 1 : 0.8)
             .onAppear {
             withAnimation(.bouncy(duration: 0.5)) {
             isAnimating = true
             }
             }
             */
            .padding(.top, 85)
            .padding(.bottom, 90)
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
            .sheet(isPresented: $isScheduleRoutineSelected, content: {
                ScheduleRoutineView(trainingRoutine: selectedTrainingRoutine, scheduleSheetHeight: $scheduleSheetHeight)
                    .presentationCornerRadius(30)
                    .presentationDetents([.height(scheduleSheetHeight)])
                    //.presentationDragIndicator(.hidden)
            })
            
        }
        TwoStyleButton(
            sheetView: CreateTrainingView(isNewTrainingPresented: $isNewTrainingPresented, currentTrainingRoutine: selectedTrainingRoutine),
            menuItems: [
                MenuItem(title: "Edit Routine", icon: "pencil", action: { print("Settings tapped") }),
                MenuItem(title: "Schedule Routine", icon: "calendar.badge.clock", action: { isScheduleRoutineSelected = true }),
                MenuItem(title: "Delete Routine", icon: "trash", action: {  })
            ],
            leftButtonLabel: Text("Add Training"),
            leftButtonIcon: "plus",
            yOffset: -100
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
        
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
    
    func getLastTrainingDate() -> Date? {
        var lastTrainingDate: Date? = nil

        // Iterate through all trainings and find the most recent one
        for training in trainings {
            // Check if the training belongs to the selected training routine
            if training.trainingRoutine == selectedTrainingRoutine {
                // If there's no lastTrainingDate yet, or if the current training's date is more recent, update it
                if let trainingDate = training.lastTrainingDate {
                    if lastTrainingDate == nil || trainingDate > lastTrainingDate! {
                        lastTrainingDate = trainingDate
                    }
                }
            }
        }
        
        return lastTrainingDate
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
