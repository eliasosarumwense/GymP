//
//  TodoDetailView.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import SwiftUI
import CoreData
import AVKit


struct DetailExerciseView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    
    var exercise: Exercise
    var training: Training?
    
    @State var isLogPresented: Bool = false
    @State var isTrainingDelivered: Bool
    @State var isExerciseForTrainingSelected: Bool = false
    
    @Binding var showNotificationIfExerciseAdded: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        List {
            Section {
                ExerciseImageView(imageName: exercise.image)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
            }
            
            Section(header: Text("Description").font(.customFont(.medium, 10))) {
                DescriptionView(description: exercise.descrip)
            }
            
            Section(header: Text("Equipment").font(.customFont(.medium, 10))) {
                EquipmentView(equipmentSet: exercise.equipment)
            }
            
            Section(header: Text("Muscles").font(.customFont(.medium, 10))) {
                MuscleView(muscleSet: exercise.muscle)
            }
            
            Section(header: Text("Logs").font(.customFont(.medium, 10))) {
                LogsView(logSet: exercise.log, formatDateToString: formatDateToString)
            }
        }
        .navigationTitle(exercise.name ?? "Exercise Details")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isTrainingDelivered {
                    SaveButton {
                        saveExerciseToTraining()
                        withAnimation {
                            showNotificationIfExerciseAdded = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showNotificationIfExerciseAdded = false
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    LogButton {
                        isLogPresented = true
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(colorSettings.selectedColor)
                }
            }
        }
        .sheet(isPresented: $isLogPresented) {
            LogExercise(exercise: exercise, isPresented: $isLogPresented)
        }
    }

    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func saveExerciseToTraining() {
        guard let training = training else { return }

        let currentExercises = training.exerciseT?.allObjects as? [Exercise] ?? []
        let highestIndex = currentExercises.map { $0.index }.max() ?? 0

        exercise.index = Int16(highestIndex + 1)
        training.addToExerciseT(exercise)

        do {
            try self.viewContext.save()
        } catch {
            print("Error saving exercise: \(error.localizedDescription)")
        }
    }
}

struct ExerciseImageView: View {
    var imageName: String?
    let player: AVPlayer

    init(imageName: String? = nil) {
        self.imageName = imageName

        if let name = imageName, let videoAsset = NSDataAsset(name: name) {
            let tempDirectoryURL = FileManager.default.temporaryDirectory
            let tempURL = tempDirectoryURL.appendingPathComponent("\(name).mp4")
            do {
                try videoAsset.data.write(to: tempURL)
                self.player = AVPlayer(url: tempURL)
            } catch {
                print("Error writing video data to temporary file: \(error)")
                self.player = AVPlayer() // Fallback
            }
        } else {
            print("Video not found in assets")
            self.player = AVPlayer()
        }
    }

    var body: some View {
        VStack {
            if player.currentItem != nil {
                VideoPlayerView(player: player)
                    .frame(height: 300)
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onAppear {
                        player.play()
                        addVideoLoopObserver()
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(width: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
    
    private func addVideoLoopObserver() {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}

struct DescriptionView: View {
    var description: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(description ?? "")
                .customFont(.regular, 14)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

struct EquipmentView: View {
    var equipmentSet: NSOrderedSet?

    var body: some View {
        VStack(alignment: .leading) {
            if let equipmentSet = equipmentSet, let equipmentArray = equipmentSet.array as? [Equipment] {
                ForEach(equipmentArray, id: \.self) { equipment in
                    Text(equipment.name ?? "")
                        .customFont(.semiBold, 15)
                        .padding(.vertical, 2)
                }
            }
        }
    }
}

struct MuscleView: View {
    var muscleSet: NSOrderedSet?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Prime Muscles:")
                .customFont(.medium, 15)
            
            if let muscleSet = muscleSet, let muscleArray = muscleSet.array as? [Muscle] {
                ForEach(muscleArray.filter { $0.intensity == "main" }, id: \.self) { muscle in
                    Text(muscle.name ?? "")
                        .customFont(.semiBold, 13)
                        .foregroundColor(.gray)
                        .padding(.vertical, 2)
                }
            }
            
            Text("Secondary Muscles:")
                .customFont(.medium, 13)
                .padding(.top, 2)
            
            if let muscleSet = muscleSet, let muscleArray = muscleSet.array as? [Muscle] {
                ForEach(muscleArray.filter { $0.intensity == "second" }, id: \.self) { muscle in
                    Text(muscle.name ?? "")
                        .customFont(.semiBold, 13)
                        .foregroundColor(.gray)
                        .padding(.vertical, 2)
                }
            }
        }
    }
}

struct LogsView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    
    var logSet: NSOrderedSet?
    var formatDateToString: (Date) -> String

    @State private var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup("Show Logs", isExpanded: $isExpanded) {
            VStack(alignment: .leading) {
                if let logSet = logSet, let logArray = logSet.array as? [Log] {
                    let limitedLogs = Array(logArray.prefix(50))
                    
                    ForEach(limitedLogs, id: \.self) { log in
                        HStack {
                            Text("\(log.reps) x \(log.weight, specifier: "%.2f") kg")
                                .customFont(.medium, 18)
                                .foregroundColor(colorSettings.selectedColor)
                            
                            if let date = log.date {
                                Text(formatDateToString(date))
                                    .customFont(.medium, 14)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    Text("No logs available for this exercise.")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 10)
        }
        .accentColor(colorSettings.selectedColor)
        //.padding()
    }
}

struct SaveButton: View {
    var action: () -> Void
    
    @EnvironmentObject var colorSettings: ColorSettings
     
    var body: some View {
        Button(action: action) {
            HStack(spacing: 1) {
                Text("Save")
                    .customFont(.regular, 15)
                    .foregroundColor(colorSettings.selectedColor)
            }
        }
    }
}

struct LogButton: View {
    var action: () -> Void
    
    @EnvironmentObject var colorSettings: ColorSettings

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(colorSettings.selectedColor)
        }
    }
}


    
    

