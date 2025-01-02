//
//  LogView.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import SwiftUI
import UIKit

struct LogView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.date, ascending: false)]
    ) private var logs: FetchedResults<Log>
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var selectedSortOption: SortOption = .dateDay
    
    @State private var isAnimating = false

    enum SortOption: String, CaseIterable {
        case dateDay = "Day"
        case dateWeek = "Week"
        case dateMonth = "Month"
        case weight = "Weight"
        case exerciseName = "Exercise Name"
        case trainingName = "Training Name"
    }
    
    var body: some View {
        VStack {
            List {
                if selectedSortOption == .weight {
                    // Display logs sorted by weight without section headers
                    ForEach(sortedLogsByWeight(), id: \.self) { log in
                        logRow(log: log)
                    }
                    .onDelete(perform: delete)
                } else if selectedSortOption == .trainingName {
                    // Group logs by training, and within each training, group by date
                    ForEach(groupedLogsByTrainingAndDate(), id: \.key) { trainingName, trainingLogs in
                        Section(header: Text("\(trainingName)").customFont(.bold, 18).foregroundColor(colorSettings.selectedColor)) {
                            ForEach(trainingLogs, id: \.key) { dateString, logs in
                                Section(header: Text(dateString).customFont(.semiBold, 15)) {
                                    ForEach(logs, id: \.self) { log in
                                        logRow(log: log)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                } else {
                    // Display grouped logs with headers for other sorting options
                    ForEach(groupedLogs(), id: \.key) { groupKey, logs in
                        Section(header: Text("\(groupKey)").customFont(.bold, 18).foregroundColor(colorSettings.selectedColor)) {
                            ForEach(logs, id: \.self) { log in
                                logRow(log: log)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
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
        .padding(.top, 95)
        .padding(.bottom, 105)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Logs")
                    .customFont(.bold, 25)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Menu("Date") {
                        Button(action: { selectedSortOption = .dateDay }) {
                            Label("Day", systemImage: "calendar")
                        }
                        Button(action: { selectedSortOption = .dateWeek }) {
                            Label("Week", systemImage: "calendar")
                        }
                        Button(action: { selectedSortOption = .dateMonth }) {
                            Label("Month", systemImage: "calendar")
                        }
                    }
                    Button(action: { selectedSortOption = .exerciseName }) {
                        Label("Exercise", systemImage: "figure.core.training")
                    }
                    Button(action: { selectedSortOption = .trainingName }) {
                        Label("Training", systemImage: "figure.strengthtraining.traditional")
                    }
                    Button(action: { selectedSortOption = .weight }) {
                        Label("Weight", systemImage: "scalemass.fill")
                    }
                } label: {
                    Text("Sort")
                        .customFont(.medium, 15)
                        .foregroundColor(colorSettings.selectedColor)
                }
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let todo = logs[index]
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
    
    // Function to group logs first by training, then by date within each training group
    private func groupedLogsByTrainingAndDate() -> [(key: String, value: [(key: String, value: [Log])])] {
        // Group by training name
        let groupedByTraining = Dictionary(grouping: logs.sorted {
            ($0.training?.name ?? "no training") < ($1.training?.name ?? "no training")
        }) { $0.training?.name ?? "no training" }
        
        // Group each training group by date
        let groupedAndSorted: [(key: String, value: [(key: String, value: [Log])])] = groupedByTraining.map { trainingName, trainingLogs in
            let groupedByDate = Dictionary(grouping: trainingLogs.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }) {
                formatDateToDDMMYYYY(date: $0.date ?? Date())
            }
            return (key: trainingName, value: groupedByDate.sorted { $0.key > $1.key })
        }
        
        // Sort by training name A-Z
        return groupedAndSorted.sorted { $0.key < $1.key }
    }

    // Function to group logs based on the selected sort option
    private func groupedLogs() -> [(key: String, value: [Log])] {
        let sortedLogs: [Log]
        
        switch selectedSortOption {
        case .dateDay:
            sortedLogs = logs.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            return Dictionary(grouping: sortedLogs) { formatDateToDDMMYYYY(date: $0.date ?? Date()) }
                .sorted { $0.key > $1.key }
            
        case .dateWeek:
            sortedLogs = logs.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            return Dictionary(grouping: sortedLogs) { formatDateToWeek(date: $0.date ?? Date()) }
                .sorted { $0.key > $1.key }
            
        case .dateMonth:
            sortedLogs = logs.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            return Dictionary(grouping: sortedLogs) { formatDateToMonth(date: $0.date ?? Date()) }
                .sorted { $0.key > $1.key }
            
        case .exerciseName:
            sortedLogs = logs.sorted { ($0.exercise?.name ?? "") < ($1.exercise?.name ?? "") }
            return Dictionary(grouping: sortedLogs) { $0.exercise?.name ?? "?" }
                .sorted { $0.key < $1.key }
            
        case .trainingName:
            // This is now handled separately in `groupedLogsByTrainingAndDate()`
            return []
            
        default:
            return []
        }
    }
    
    // Function to sort logs by weight
    private func sortedLogsByWeight() -> [Log] {
        return logs.sorted { $0.weight > $1.weight }
    }
    
    // View for each log row
    private func logRow(log: Log) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                VStack {
                    // Exercise name display (exclude if sorted by exercise name)
                    if selectedSortOption != .exerciseName {
                        HStack (spacing: 2) {
                            Text("\(log.exercise?.name ?? "Exercise does not exist anymore")")
                                .customFont(.bold, 15)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }

                    // Training name display (exclude if sorted by training name)
                    if selectedSortOption != .trainingName {
                        HStack(spacing: 2) {
                            Text("Training: ")
                                .customFont(.medium, 12)
                                .foregroundStyle(.gray)
                            Text("\(log.training?.name ?? "no training")")
                                .customFont(.medium, 12)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }

                    // Display relevant information based on other conditions
                    HStack {
                        if let index = log.trainingTemplate?.index, log.training != nil {
                            Text("\(index). ")
                                .customFont(.medium, 10)
                                .foregroundStyle(Color(.lightGray))
                        }
                        Text("\(log.reps) x \(log.weight, specifier: "%.2f") kg")
                            .customFont(.medium, 14)
                            .foregroundColor(.primary)
                        Spacer()

                        // Date display (exclude full date if sorted by day, only show hours)
                        if selectedSortOption == .dateDay {
                            Text(formatDateToHours(date: log.date ?? Date()))
                                .customFont(.light, 13)
                                .foregroundColor(.primary)
                        } else {
                            Text(formatDateToDateAndHours(date: log.date ?? Date()))
                                .customFont(.light, 13)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.top, 5)
                }
            }
            Spacer()
        }
    }

    // Helper function to format time to just hours (HH:mm)
    private func formatDateToHours(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // Helper function to format date to "dd.MM.yyyy"
    private func formatDateToDDMMYYYY(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    // Helper function to format date to "year CW weeknumber"
    private func formatDateToWeek(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return "CW \(weekOfYear) \(year) "
    }
    
    // Helper function to format date to month
    private func formatDateToMonth(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
