//
//  InstanceLogView.swift
//  GymP
//
//  Created by Elias Osarumwense on 24.07.24.
//

import SwiftUI

struct InstanceLogView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var colorSettings: ColorSettings

    @Binding var trainingInstanceID: UUID

    @FetchRequest(sortDescriptors: []) private var instances: FetchedResults<TrainingInstance>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showDeleteAlert = false  // State variable for showing the delete confirmation alert

    private var activeInstance: TrainingInstance? {
        return instances.first { $0.id == trainingInstanceID }
    }

    var body: some View {
        VStack {
            HStack (spacing: 2){
                Text("\(formatDateToDateOnly(date: activeInstance?.date ?? Date()))")
                    .customFont(.semiBold, 18)
                Text("on")
                    .customFont(.semiBold, 18)
                Text("\(formatDateToHoursAndMinutes(date: activeInstance?.trainingstart ?? Date()))")
                    .customFont(.medium, 17)
                Text("-")
                    .customFont(.medium, 17)
                Text("\(formatDateToHoursAndMinutes(date: activeInstance?.trainingend ?? Date()))")
                    .customFont(.medium, 17)
            }
            .padding(5)
            if let activeInstance = activeInstance {
                List {
                    // Group logs by exercise
                    let groupedLogs = Dictionary(grouping: activeInstance.logsArray) { $0.exercise }

                    ForEach(groupedLogs.keys.sorted(by: { $0?.name ?? "" < $1?.name ?? "" }), id: \.self) { exercise in
                        if let exercise = exercise {
                            DisclosureGroup {
                                ForEach(groupedLogs[exercise] ?? [], id: \.self) { log in
                                    HStack {
                                        HStack {
                                            Text("\(log.reps)")
                                                .customFont(.medium, 17)
                                            Text("x")
                                                .customFont(.medium, 17)
                                                .foregroundColor(colorSettings.selectedColor)
                                            Text("\(log.weight, specifier: "%.2f") kg")
                                                .customFont(.medium, 17)
                                        }
                                        Spacer()
                                        Text("\(formatDateToHoursAndMinutes(date: log.date ?? Date()))")
                                            .customFont(.light, 15)
                                    }
                                    .padding()
                                }
                            } label: {
                                Text(exercise.name ?? "Unnamed Exercise")
                                    .customFont(.bold, 16)
                            }
                            .accentColor(colorSettings.selectedColor)
                            //.padding(.vertical, 5)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            } else {
                Text("No active training instance found.")
                    .foregroundColor(.gray)
                    .customFont(.medium, 15)
            }
        }
        .padding(2)
        .navigationTitle("\(activeInstance?.training?.name ?? "Deleted Training")")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(colorSettings.selectedColor)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    // New button to navigate to TrainingDetailView
                    if let training = activeInstance?.training {
                        NavigationLink(destination: TrainingDetailView(training: training)) {
                            Image(systemName: "info.circle")
                                .foregroundColor(colorSettings.selectedColor)
                        }
                    }
                    // Trash button for deletion
                    Button(action: {
                        showDeleteAlert = true  // Show the delete confirmation alert
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Training Session"),
                message: Text("Are you sure you want to delete this training session? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let instanceToDelete = activeInstance {
                        deleteInstance(instanceToDelete)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func deleteInstance(_ instance: TrainingInstance) {
        viewContext.delete(instance)
        do {
            try viewContext.save()  // Save the context after deletion
            presentationMode.wrappedValue.dismiss()  // Dismiss the view
        } catch {
            // Handle the Core Data error
            print("Failed to delete instance: \(error.localizedDescription)")
        }
    }
    
    private func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension TrainingInstance {
    var logsArray: [Log] {
        let set = log as? Set<Log> ?? []
        return set.sorted { $0.date ?? Date() < $1.date ?? Date() }
    }
}

