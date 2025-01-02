//
//  LogExercise.swift
//  GymP
//
//  Created by Elias Osarumwense on 18.06.24.
//

import SwiftUI

struct LogExercise: View {
    @EnvironmentObject var colorSettings: ColorSettings
    var exercise: Exercise
    @Binding var isPresented: Bool
    
    @State private var selectedRepsIndex: Int = 0
    @State private var selectedWeightIndex: Int = 0
    @State private var selectedWeightAfterSemicolonIndex: Int = 0
    let weightOptions = Array(0...1000)
    let weightOptionsAfterSemicolon = [0, 25, 50, 75]
    let repetions = Array(0...100)
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        VStack {
            Text("\(exercise.name ?? "")")
                .font(.system(size: 24, weight: .bold, design: .default))
            HStack {
                    Picker(selection: $selectedRepsIndex, label: Text("Select Reps")) {
                        ForEach(0 ..< 100) { index in
                            Text("\(repetions[index])").tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                Text("x")
                    HStack {
                        Picker(selection: $selectedWeightIndex, label: Text("Select Weight")) {
                            ForEach(0 ..< 1000) { index in
                                Text("\(weightOptions[index])").tag(index)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        Text(",")
                        Picker(selection: $selectedWeightAfterSemicolonIndex, label: Text("Select Weight")) {
                            ForEach(0 ..< 4) { index in
                                Text("\(weightOptionsAfterSemicolon[index])").tag(index)
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // Optional: Use a different picker style if desired
                        Text("kg")
                    }
            }
                        Text("Selected Weight: \(weightOptions[selectedWeightIndex]),\(weightOptionsAfterSemicolon[selectedWeightAfterSemicolonIndex]) kg")
                .font(.system(size: 18, weight: .bold, design: .default))
                            .padding()
            
            Button("Save")
            {
                SaveLogExercise()
                isPresented = false
            }
        }
        .ignoresSafeArea()
        //.padding()
        .navigationTitle("\(exercise.name!)")
        
    }
    
    func combineIntegers(first: Int, second: Int) -> Double {
        let combinedString = "\(first).\(second)"
        if let combinedDouble = Double(combinedString) {
            return combinedDouble
        } else {
            // Handle error case if parsing fails
            fatalError("Failed to convert combined string to Double")
        }
    }
    
    func SaveLogExercise()
    {
        let newLog = Log(context: self.viewContext)
        newLog.id = UUID()
        newLog.date = Date()
        newLog.reps = Int32(selectedRepsIndex)
        newLog.weight = combineIntegers(first: selectedWeightIndex, second: selectedWeightAfterSemicolonIndex)
        newLog.exercise = exercise
        exercise.addToLog(newLog)
        
        print("\(newLog.exercise?.name)")
        do {
            try self.viewContext.save()
            print("Log saved!")
            
        } catch {
            print("Whoops \(error.localizedDescription)")
        }
    }
}

