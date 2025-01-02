//
//  TraininginstancesView.swift
//  GymP
//
//  Created by Elias Osarumwense on 25.07.24.
//

import SwiftUI
import CoreData

struct TrainingInstancesView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingInstance.trainingstart, ascending: false)]
    ) private var instances: FetchedResults<TrainingInstance>
    
    @EnvironmentObject var manager: DataManager
    @EnvironmentObject var trainingState: TrainingState
    @Environment(\.managedObjectContext) var viewContext
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedInstanceID: UUID? // State to track the selected instance ID
    @State private var expandedSections: Set<Int> = [] // State to track expanded sections
    
    var training: Training
    
    var body: some View {
        VStack {
            List {
                            ForEach(groupByYearThenMonth(filteredInstances: instances.filter { $0.training?.id == training.id }).keys.sorted(by: >), id: \.self) { year in
                                Section(header: Text("\(year)").customFont(.bold, 20)) {
                                    
                                    ForEach(groupByYearThenMonth(filteredInstances: instances.filter { $0.training?.id == training.id })[year]?.keys.sorted(by: >) ?? [], id: \.self) { month in
                                        DisclosureGroup(
                                            isExpanded: Binding(
                                                get: { expandedSections.contains(month) },
                                                set: { isExpanded in
                                                    if isExpanded {
                                                        expandedSections.insert(month)
                                                    } else {
                                                        expandedSections.remove(month)
                                                    }
                                                }
                                                    
                                            )
                                            ,
                                            content: {
                                                ForEach(groupByYearThenMonth(filteredInstances: instances.filter { $0.training?.id == training.id })[year]?[month]?.sorted(by: { $0.trainingstart ?? Date() > $1.trainingstart ?? Date() }) ?? [], id: \.self) { log in
                                                    NavigationLink(destination: InstanceLogView(trainingInstanceID: .constant(log.id ?? UUID()))) {
                                                        HStack(alignment: .center) {
                                                            VStack(alignment: .leading) {
                                                                HStack {
                                                                    VStack(alignment: .leading) {
                                                                        HStack (spacing: 5) {
                                                                            Text(formatDateToDateOrFullDayName(date: log.trainingstart ?? Date()))
                                                                                .customFont(.medium, 15)
                                                                            Text(formatDateToHoursAndMinutes(date: log.trainingstart ?? Date()))
                                                                                .customFont(.light, 15)
                                                                            Text("-")
                                                                            Text(formatDateToHoursAndMinutes(date: log.trainingend ?? Date()))
                                                                                .customFont(.light, 15)
                                                                        }
                                                                        Text(formatDuration(start: log.trainingstart ?? Date(), end: log.trainingend ?? Date()))
                                                                            .customFont(.medium, 13)
                                                                    }
                                                                    Spacer()
                                                                }
                                                                Text("\(log.log?.count ?? 0) Sets")
                                                                    .customFont(.medium, 15)
                                                                    .foregroundColor(colorSettings.selectedColor)
                                                            }
                                                            Spacer()
                                                        }
                                                        .padding()
                                                        .background(
                                                            log.id == trainingState.activeInstanceID ? Color.green.opacity(0.3) : Color.clear
                                                        )
                                                        .cornerRadius(10) // Ensure background visibility
                                                    }
                                                }
                                            },
                                            label: {
                                                Text(DateComponents(calendar: Calendar.current, month: month).date!.monthName()).customFont(.bold, 16)
     
                                            }
                                            
                                        )
                                        .accentColor(colorSettings.selectedColor)
                                    }
                                }
                            }
                        }
            //.listStyle(.inset)
            //.padding()
        }
        .navigationTitle("\(training.name ?? "Dummy") Sessions")
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
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let todo = instances[index]
            self.viewContext.delete(todo)
            
            do {
                try viewContext.save()
                print("perform delete")
            } catch {
                // handle the Core Data error
            }
        }
    }
    
    private func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MMMM HH:mm"
        return formatter.string(from: date)
    }
    
    
    
    private func groupByYearThenMonth(filteredInstances: [TrainingInstance]) -> [Int: [Int: [TrainingInstance]]] {
        let calendar = Calendar.current
        var groupedByYearThenMonth: [Int: [Int: [TrainingInstance]]] = [:]
        
        for instance in filteredInstances {
            let year = calendar.component(.year, from: instance.trainingstart ?? Date())
            let month = calendar.component(.month, from: instance.trainingstart ?? Date())
            
            if groupedByYearThenMonth[year] == nil {
                groupedByYearThenMonth[year] = [:]
            }
            if groupedByYearThenMonth[year]?[month] == nil {
                groupedByYearThenMonth[year]?[month] = []
            }
            
            groupedByYearThenMonth[year]?[month]?.append(instance)
        }
        
        return groupedByYearThenMonth
    }
}
extension Date {
    func monthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
}


