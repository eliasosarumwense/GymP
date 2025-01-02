//
//  MusclesView.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//
import SwiftUI

struct MusclesView: View {
    
    @FetchRequest(sortDescriptors: []) private var muscles: FetchedResults<Muscle>
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var selectedMuscle: String = "Chest"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                muscleGroupPicker
                
                List {
                    ForEach(getMusclesForSelectedGroup(), id: \.self) { muscleName in
                        Text(muscleName)
                            .customFont(.semiBold, 25)
                            .foregroundColor(.orange)
                            .padding(.vertical, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("Muscles")
        }
    }
    
    private var muscleGroupPicker: some View {
        Picker("Select muscle group", selection: $selectedMuscle) {
            ForEach(["Chest", "Back", "Biceps", "Triceps", "Legs"], id: \.self) { group in
                Text(group).tag(group)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private func getMusclesForSelectedGroup() -> [String] {
        switch selectedMuscle {
        case "Chest":
            return uniqueMuscleNames().filter { $0 == "Chest" }
        case "Back":
            return uniqueMuscleNames().filter { ["Lat", "Upper Back", "Trapezius", "Middle Back", "Lower Back"].contains($0) }
        case "Biceps":
            return uniqueMuscleNames().filter { $0 == "Biceps" }
        case "Triceps":
            return uniqueMuscleNames().filter { $0 == "Triceps" }
        case "Legs":
            return uniqueMuscleNames().filter { ["Quadriceps", "Hamstrings", "Calves", "Glutes"].contains($0) }
        default:
            return []
        }
    }
    
    private func uniqueMuscleNames() -> [String] {
        let muscleNames = muscles.compactMap { $0.name }
        return Array(Set(muscleNames)).sorted()
    }
}
