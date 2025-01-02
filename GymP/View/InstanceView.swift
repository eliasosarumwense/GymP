//
//  InstanceView.swift
//  GymP
//
//  Created by Elias Osarumwense on 23.07.24.
//

import SwiftUI
import CoreData
import Charts

struct InstanceView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var colorSettings: ColorSettings
    @FetchRequest(
        entity: TrainingInstance.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingInstance.date, ascending: false)] // Sort by latest first
    ) private var instances: FetchedResults<TrainingInstance>
    
    @EnvironmentObject var manager: DataManager
    @EnvironmentObject var trainingState: TrainingState
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var displayedYear: String = "" // State to display the year on top
    @State private var groupingMode: GroupingMode = .day // Default grouping mode is day
    private let calendar = Calendar.current
    
    @State private var isCustomDateRange: Bool = false // Toggle for custom date range
    @State private var customStartDate: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @State private var instanceCount: Int = 0
    
    @State private var isSheetPresented = false
    
    @State private var selectedRange: TimeRange = .fromFirstSession
    
    @State private var isChartSheetPresented = false

    @State private var selectedCalenderType: CalenderType = .timeline
    
    @State private var selectedDate = Date()
    
    @EnvironmentObject var context: TabControllerContext
    
    @State private var isAnimating = false
    
    enum CalenderType: String, CaseIterable {
        case timeline = "Timeline"
        case calender = "Calendar"
    }
    
    enum GroupingMode {
        case day
        case week
        case month
    }
    
    private var instanceArray: [TrainingInstance] {
            return instances.map { $0 }
        }
    
    var body: some View {
        VStack {
            ZStack {
                // Scrollable content in the background
                ScrollView(.vertical) {
                    VStack {
                        VStack {
                            Picker("Calendar Type", selection: $selectedCalenderType) {
                                ForEach(CalenderType.allCases, id: \.self) { type in
                                    Text(type.rawValue)
                                        .font(Font.custom("Lexend-Medium", size: 10))
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.leading)
                            .padding(.trailing)
                            .animation(.linear, value: selectedCalenderType)
                        }
                        .frame(width: 350)
                        //.padding(.top, 1)
                        if selectedCalenderType == .timeline {
                            
                            VStack (alignment: .leading) {
                                Text("Stats").textCase(.uppercase)
                                    .font(.customFont(.medium, 10))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                //.padding(.leading, -100))
                                Section {
                                    
                                    HStack {
                                        VStack {
                                            // Display the number of instances in the selected period
                                            HStack {
                                                Text("All Sessions:")
                                                    .customFont(.medium, 11)  // Smaller font for the label
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                    .frame(width: 120, alignment: .leading)  // Fixed width for the label column
                                                
                                                Text("\(instanceCount)")
                                                    .customFont(.medium, 13)  // Larger font for the value
                                                    .frame(alignment: .leading)
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            HStack {
                                                Text("Sessions this Month:")
                                                    .customFont(.medium, 11)  // Smaller font for the label
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                    .frame(width: 120, alignment: .leading)  // Fixed width for the label column
                                                
                                                Text("\(calculateInstancesThisMonth())")
                                                    .customFont(.medium, 13)  // Larger font for the value
                                                    .frame(alignment: .leading)
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            // Display total instances per year
                                            HStack {
                                                Text("Sessions this Year:")
                                                    .customFont(.medium, 11)  // Smaller font for the label
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                    .frame(width: 120, alignment: .leading)  // Fixed width for the label column
                                                
                                                Text("\(calculateInstancesPerYear())")
                                                    .customFont(.medium, 13)  // Larger font for the value
                                                    .frame(alignment: .leading)
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            
                                            // Display average instances per month
                                            HStack {
                                                Text("Ø Sessions in a Month:")
                                                    .customFont(.medium, 11)  // Smaller font for the label
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                    .frame(width: 120, alignment: .leading)  // Fixed width for the label column
                                                
                                                Text("\(String(format: "%.2f", calculateAverageInstancesPerMonth()))") // Format with 2 decimal places
                                                    .customFont(.medium, 13)  // Larger font for the value
                                                    .frame(alignment: .leading)
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                            
                                            // Display average instances per week
                                            HStack {
                                                Text("Ø Sessions in a Week:")
                                                    .customFont(.medium, 11)  // Smaller font for the label
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                    .frame(width: 120, alignment: .leading)  // Fixed width for the label column
                                                
                                                Text("\(String(format: "%.2f", calculateAverageInstancesPerWeek()))") // Format with 2 decimal places
                                                    .customFont(.medium, 13)  // Larger font for the value
                                                    .frame(alignment: .leading)
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 5)
                                        }
                                        .padding(.vertical, 10)  // Padding inside the section content
                                        .padding(.leading, 10)
                                        VStack {
                                                // Display total duration spent
                                                HStack {
                                                    Text("Total Time Spent:")
                                                        .customFont(.medium, 11)
                                                        .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                        .frame(width: 100, alignment: .leading)
                                                    Text("\(formatTotalDuration(calculateTotalDuration()))")
                                                        .customFont(.medium, 13)
                                                        .frame(alignment: .leading)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 5)
                                                
                                                // Display total time spent this month
                                                HStack {
                                                    Text("Time This Month:")
                                                        .customFont(.medium, 11)
                                                        .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                        .frame(width: 100, alignment: .leading)
                                                    Text("\(formatTotalDuration(calculateTotalDurationThisMonth()))")
                                                        .customFont(.medium, 13)
                                                        .frame(alignment: .leading)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 5)
                                                
                                                // Display total time spent this year
                                                HStack {
                                                    Text("Time This Year:")
                                                        .customFont(.medium, 11)
                                                        .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                        .frame(width: 100, alignment: .leading)
                                                    Text("\(formatTotalDuration(calculateTotalDurationThisYear()))")
                                                        .customFont(.medium, 13)
                                                        .frame(alignment: .leading)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 5)
                                                
                                                // Display average time per training instance
                                                HStack {
                                                    Text("Ø Time Per Session:")
                                                        .customFont(.medium, 11)
                                                        .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                        .frame(width: 100, alignment: .leading)
                                                    Text("\(formatMinutes(calculateAverageDurationPerInstance())) mins")
                                                        .customFont(.medium, 13)
                                                        .frame(alignment: .leading)
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 5)
                                            }
                                        .padding(.vertical, 10)
                                        .padding(.trailing, 10)
                                    }
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                Text("Total Weight Lifted")
                                                    .customFont(.regular, 12)
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                Text("\(calculateTotalWeight(), specifier: "%.2f") kg") // Display total weight
                                                    .customFont(.medium, 14)
                                            }
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                Text("Total Reps")
                                                    .customFont(.medium, 12)
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                Text("\(calculateTotalReps())") // Display total reps
                                                    .customFont(.medium, 14)
                                            }
                                            
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                Text("Total Sets")
                                                    .customFont(.medium, 12)
                                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                                                Text("\(calculateTotalSets())") // Display total sets
                                                    .customFont(.medium, 14)
                                            }
                                            Spacer()
                                        }
                                        //.padding(.horizontal, 10)
                                        //.padding(.top, 10)
                                    }
                                    .frame(height: 50)
                                    
                                }
                                .frame(maxWidth: 370)  // Custom max width for the section
                                .background(colorScheme == .dark ? Color(.darkGray).opacity(0.3) : Color(.gray).opacity(0.3)) // Background color based on dark/light mode
                                .cornerRadius(15)  // Rounded corners for the section
                            }
                            .padding(.top, 10)
                        }
                    }
                    .padding(.top, 10)
                    if selectedCalenderType == .timeline {
                        Text("Timeline").textCase(.uppercase)
                            .font(.customFont(.medium, 10))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 5)
                        Section {
                            HStack(spacing: 7) {
                                Text("From")
                                    .customFont(.medium, 13)
                                    .foregroundColor(.primary)
                                
                                // Calculate the earliestInstanceDate
                                let earliestInstanceDate = instances.min(by: { $0.date ?? Date() < $1.date ?? Date() })?.date ?? Date()
                                
                                Button(action: {
                                    customStartDate = earliestInstanceDate
                                    selectedRange = .fromFirstSession
                                }) {
                                    Text("1st Session")
                                        .customFont(.medium, 13)
                                        .padding(6)
                                        .background(customStartDate == earliestInstanceDate ? colorSettings.selectedColor : Color.gray) // Grayed out if dates don't match
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                                Text("or")
                                    .customFont(.medium, 13)
                                    .foregroundColor(.primary)
                                // Highlight the DatePicker text in red if the date doesn't match earliestInstanceDate
                                DatePicker("", selection: $customStartDate, displayedComponents: .date)
                                    .font(.customFont(.semiBold, 20))
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .labelsHidden()
                                    .accentColor(customStartDate != earliestInstanceDate ? .red : colorSettings.selectedColor) // Red when date doesn't match
                                    .colorScheme(.dark)
                                    .transformEffect(.init(scaleX: 0.9, y: 0.9))
                                    
                                
                                // Grayed out button if date doesn't match earliestInstanceDate
                                
                                
                                //.disabled(customStartDate != earliestInstanceDate) // Disable button when dates don't match
                            }
                            .offset(x: 4, y: -7)
                            .padding(5)
                            
                            
                        }
                        .onAppear {
                            // Set default to one year ago and mark the selected range
                            if let earliestInstanceDate = instances.min(by: { $0.date ?? Date() < $1.date ?? Date() })?.date {
                                customStartDate = earliestInstanceDate
                                selectedRange = .fromFirstSession
                            }
                        }
                        .padding(.top, 15)
                        .frame(maxWidth: 250)  // Custom max width for the section
                        .background(colorScheme == .dark ? Color(.darkGray).opacity(0.3) : Color(.gray).opacity(0.3)) // Background color based on dark/light mode
                        .cornerRadius(10)
                    }
                    if selectedCalenderType == .timeline {
                        
                        LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
                                let dates = generateDateRange()
                                
                                // Group the dates by year and month
                            let groupedDates = Dictionary(grouping: dates) { date -> YearMonth in
                                        let calendar = Calendar.current
                                        let year = calendar.component(.year, from: date)
                                        let month = calendar.component(.month, from: date)
                                        return YearMonth(year: year, month: month)
                                    }
                                    
                                    // Sort the grouped dates by year and month
                                    let sortedKeys = groupedDates.keys.sorted()
                                
                                // Iterate through each grouped month and year in sorted order
                                ForEach(sortedKeys, id: \.self) { key in
                                    if let firstDateInMonth = groupedDates[key]?.first {
                                        let year = key.year
                                        let monthName = DateFormatter().monthSymbols[key.month - 1] // Get the month name from the month number
                                        
                                        Section(header: HStack (spacing: 5){
                                            Text(monthName)
                                                .customFont(.semiBold, 15)
                                                .foregroundColor(.primary)
   
                                            Text(String(year))
                                                .customFont(.semiBold, 15)
                                                .foregroundColor(.primary)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.top, 5)
                                        .background(
                                            Color(UIColor.systemBackground))
                                        ) {
                                            ForEach(groupedDates[key] ?? [], id: \.self) { date in
                                                let instancesForDate = instancesForDate(date: date)
                                                let hasInstance = !(instancesForDate?.isEmpty ?? true)
                                                
                                                ZStack {
                                                    Color.clear
                                                        .frame(height: hasInstance ? 80 : 20)
                                                    
                                                    GeometryReader { geo in
                                                        let isAligned = abs(geo.frame(in: .global).midY - UIScreen.main.bounds.height / 2) < 20
                                                        let fontSize: CGFloat = isAligned ? (hasInstance ? 17 : 11) : (hasInstance ? 14 : 9)
                                                        
                                                        HStack {
                                                            VStack(alignment: .leading) {
                                                                Spacer()
                                                                Text(formatDateRangeToString(date: date))
                                                                    .customFont(hasInstance ? .bold : .medium, fontSize)
                                                                    .animation(.smooth(duration: 0.2), value: isAligned)
                                                                    .onChange(of: isAligned) { newValue in
                                                                        if newValue {
                                                                            //triggerHapticFeedbackLight()
                                                                            triggerHapticFeedbackRigid()
                                                                        }
                                                                    }
                                                                Spacer()
                                                            }
                                                            .frame(width: 150)
                                                            
                                                            if let instances = instancesForDate, !instances.isEmpty {
                                                                VStack(alignment: .leading, spacing: 0) {
                                                                    if groupingMode == .day {
                                                                        ForEach(instances, id: \.self) { log in
                                                                            NavigationLink(destination: InstanceLogView(trainingInstanceID: .constant(log.id ?? UUID()))) {
                                                                                VStack(alignment: .leading) {
                                                                                    Text("\(log.training?.name ?? "-")")
                                                                                        .customFont(.medium, 16)
                                                                                        .foregroundColor(log.training == nil ? .red : .primary)
                                                                                    
                                                                                    let totalSets = log.training?.trainingTexercise?.count ?? 0
                                                                                    let completedSets = log.log?.count ?? 0
                                                                                    
                                                                                    HStack {
                                                                                        Text("\(completedSets)/\(totalSets) Sets done")
                                                                                            .customFont(.regular, 12)
                                                                                            .foregroundColor(.gray)
                                                                                    }
                                                                                    if let start = log.trainingstart, let end = log.trainingend {
                                                                                        HStack(spacing: 2) {
                                                                                            Text("\(formatTime(date: start)) - \(formatTime(date: end))")
                                                                                                .customFont(.medium, 12)
                                                                                                .foregroundColor(.primary)
                                                                                            Text("-")
                                                                                                .customFont(.medium, 12)
                                                                                                .foregroundColor(.primary)
                                                                                            Text(formatDuration(start: log.trainingstart ?? Date(), end: log.trainingend ?? Date()))
                                                                                                .customFont(.medium, 12)
                                                                                                .foregroundStyle(colorSettings.selectedColor)
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    } else {
                                                                        Text("\(instances.count) Sessions")
                                                                            .customFont(.medium, 16)
                                                                            .foregroundColor(.primary)
                                                                           
                                                                    }
                                                                }
                                                                .frame(height: 80)
                                                            } else {
                                                                Spacer().frame(height: 40)
                                                            }
                                                            
                                                            Spacer()
                                                        }
                                                        .background(Color.gray.opacity(0.1))
                                                        .cornerRadius(10)
                                                    }
                                                }
                                                .frame(height: hasInstance ? 80 : 40)
                                            }
                                        }
                                    }
                                }
                            }
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                        Rectangle()
                            .hidden()
                            .frame(height: 370)
                    }
                    if selectedCalenderType == .calender {
                        VStack {
                            CustomCompactDatePickerView(selectedDate: $selectedDate, instances: instanceArray)
                                //.environmentObject(colorSettings)
                            InstancesForSelectedDateView(selectedDate: selectedDate, instances: instanceArray)
                        }
                        .animation(.linear, value: selectedCalenderType)
                        .padding(.vertical)
                    }
                    
                }
                .onAppear {
                    calculateInstanceCount() // Initial calculation
                }
                .onChange(of: isCustomDateRange) { _ in
                    calculateInstanceCount() // Recalculate instances when toggle changes
                }
                
                // Fixed rectangle in the center of the screen, on top of the scrolling content
                if selectedCalenderType == .timeline {
                    VStack {
                        Spacer()
                        /*Rectangle()
                         .frame(height: 1)
                         .foregroundStyle(.gray.opacity(0.8))
                         */
                        HStack {
                            Image(systemName: "arrowtriangle.right.fill")
                                .font(.footnote)
                                .foregroundColor(colorSettings.selectedColor)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top, -90)
                    .padding(.bottom, -110)
                    .ignoresSafeArea()
                    .zIndex(1) // Ensures the rectangle stays on top
                }
            }
            
        }

        .padding(.top, 95)
        //.padding(.bottom, 100)
            //.navigationBarTitle("Sessions", displayMode: .inline)
                    .toolbar {
                        
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack (spacing: 15){
                                
                                Button(action: {
                                    isChartSheetPresented = true
                                }) {
                                    Image(systemName: "chart.bar.xaxis")
                                    //.font(.subheadline)
                                        .foregroundColor(colorSettings.selectedColor)
                                }
                                
                                
                                    menu
                                        //.offset(x: selectedCalenderType == .timeline ? 0 : UIScreen.main.bounds.width)
                                        //.animation(.smooth(duration: 0.3), value: selectedCalenderType)
                                
                                
                                
                            }
                            .offset(x: selectedCalenderType == .timeline ? 0 : 48)
                            .animation(.easeInOut(duration: 0.4), value: selectedCalenderType)
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text("Sessions")
                                .customFont(.bold, 25)
                        }
                    }
                    .sheet(isPresented: $isChartSheetPresented) {
                        InstanceChartView()
                            .environmentObject(colorSettings)
                    }
    }

    
    private func calculateInstanceCount() {
        let startDate = isCustomDateRange ? customStartDate : calendar.date(byAdding: .year, value: -1, to: Date())!
        instanceCount = instances.filter { instance in
            if let instanceDate = instance.date {
                return instanceDate >= startDate
            }
            return false
        }.count
    }
    
    // Menu with "Day", "Week", and "Month" buttons
    private var menu: some View {
        Menu {
            Button(action: { groupingMode = .day }) {
                Label("Group by Day", systemImage: "calendar")
                    .foregroundColor(groupingMode == .day ? .gray : .primary) // Gray out when selected
            }
            .disabled(groupingMode == .day) // Disable when selected
            
            Button(action: { groupingMode = .week }) {
                Label("Group by Week", systemImage: "calendar.day.timeline.left")
                    .foregroundColor(groupingMode == .week ? .gray : .primary) // Gray out when selected
            }
            .disabled(groupingMode == .week) // Disable when selected
            
            Button(action: { groupingMode = .month }) {
                Label("Group by Month", systemImage: "calendar.day.timeline.left")
                    .foregroundColor(groupingMode == .month ? .gray : .primary) // Gray out when selected
            }
            .disabled(groupingMode == .month) // Disable when selected
        } label: {
            Image(systemName: "list.bullet.below.rectangle")
                .foregroundColor(colorSettings.selectedColor)
        }
    }
    
    // Function to generate a range of dates, weeks, or months
    private func generateDateRange() -> [Date] {
        var dates: [Date] = []
        
        // Determine the starting date based on custom range or default to 1 year ago
        let startDate = customStartDate
        let endDate = Calendar.current.startOfDay(for: Date()) // Align to start of today
        
        var date = Calendar.current.startOfDay(for: startDate) // Align to start of startDate
        
        // Generate dates based on the selected grouping mode
        while date <= endDate {
            switch groupingMode {
            case .day:
                dates.append(date)
                date = calendar.date(byAdding: .day, value: 1, to: date)!
            case .week:
                if let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start {
                    dates.append(startOfWeek)
                    date = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
                }
            case .month:
                if let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start {
                    dates.append(startOfMonth)
                    date = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
                }
            }
        }
        
        // Return the array with the earliest date at the bottom
        return dates.reversed()
    }
    
    // Helper function to format date range string
    private func formatDateRangeToString(date: Date) -> String {
        switch groupingMode {
        case .day:
            return formatDateToString(date: date)
        case .week:
            if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM"
                let startDate = formatter.string(from: weekInterval.start)
                let endDate = formatter.string(from: weekInterval.end)
                return "\(startDate) - \(endDate)"
            }
            return ""
        case .month:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM" // Display the month name
            return formatter.string(from: date)
        }
    }
    
    // Helper function to format date as a string
    private func formatDateToString(date: Date) -> String {
        if isDateWithinOneWeek(date: date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE. dd.MM"
            return formatter.string(from: date)
        }
    }
    
    private func formatMonthName(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // Full month name
        return formatter.string(from: date)
    }
    
    // Helper function to check if the date is within one week of the current date
    private func isDateWithinOneWeek(date: Date) -> Bool {
        let today = Date()
        if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today) {
            return date >= oneWeekAgo && date <= today
        }
        return false
    }
    
    // Helper function to format year as a string
    private func formatYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    
    // Helper function to filter instances for a specific date, week, or month
    private func instancesForDate(date: Date) -> [TrainingInstance]? {
        switch groupingMode {
        case .day:
            let filteredInstances = instances.filter { instance in
                if let instanceDate = instance.date {
                    return calendar.isDate(instanceDate, inSameDayAs: date)
                }
                return false
            }
            return filteredInstances.isEmpty ? nil : filteredInstances
            
        case .week:
            let filteredInstances = instances.filter { instance in
                if let instanceDate = instance.date,
                   let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) {
                    return instanceDate >= weekInterval.start && instanceDate < weekInterval.end
                }
                return false
            }
            return filteredInstances.isEmpty ? nil : filteredInstances
            
        case .month:
            let filteredInstances = instances.filter { instance in
                if let instanceDate = instance.date,
                   let monthInterval = calendar.dateInterval(of: .month, for: date) {
                    return instanceDate >= monthInterval.start && instanceDate < monthInterval.end
                }
                return false
            }
            return filteredInstances.isEmpty ? nil : filteredInstances
        }
    }
    
    // Helper function to format duration
    private func formatDuration(start: Date, end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let minutes = Int(duration) / 60
        return "\(minutes) mins"
    }
    
    private func calculateInstancesPerYear() -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        let filteredInstances = instances.filter { instance in
            if let instanceDate = instance.date {
                return calendar.component(.year, from: instanceDate) == currentYear
            }
            return false
        }
        
        return filteredInstances.count
    }
    
    private func calculateInstancesThisMonth() -> Int {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        
        let filteredInstances = instances.filter { instance in
            if let instanceDate = instance.date {
                return calendar.component(.month, from: instanceDate) == currentMonth
            }
            return false
        }
        
        return filteredInstances.count
    }
    
    private func calculateAverageInstancesPerMonth() -> Double {
        let calendar = Calendar.current
        let startDate = customStartDate
        
        let endDate = Date() // End date is always today

        // Ensure startDate is before or equal to endDate
        guard startDate <= endDate else { return 0 }

        // Filter instances within the selected range
        let filteredInstances = instances.filter { instance in
            if let instanceDate = instance.date {
                return instanceDate >= startDate && instanceDate <= endDate
            }
            return false
        }

        // Calculate the number of months in the selected range
        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        let numberOfMonths = Double(components.month ?? 0) + 1 // Ensure minimum 1 month

        // Avoid division by zero
        if numberOfMonths <= 0 {
            return 0
        }

        // Calculate the average instances per month
        return Double(filteredInstances.count) / numberOfMonths
    }

    private func calculateAverageInstancesPerWeek() -> Double {
        let calendar = Calendar.current
        let startDate = customStartDate
        
        let endDate = Date() // End date is always today

        // Ensure startDate is before or equal to endDate
        guard startDate <= endDate else { return 0 }

        // Filter instances within the selected range
        let filteredInstances = instances.filter { instance in
            if let instanceDate = instance.date {
                return instanceDate >= startDate && instanceDate <= endDate
            }
            return false
        }

        // Calculate the number of weeks in the selected range
        let components = calendar.dateComponents([.weekOfYear], from: startDate, to: endDate)
        let numberOfWeeks = Double(components.weekOfYear ?? 0) + 1 // Ensure minimum 1 week

        // Avoid division by zero
        if numberOfWeeks <= 0 {
            return 0
        }

        // Calculate the average instances per week
        return Double(filteredInstances.count) / numberOfWeeks
    }
    
    private func calculateInstancesPerDayOfWeek() -> [String: Int] {
        // Create an ordered array starting with Monday
        var dayOfWeekCounts: [String: Int] = [
            "Mon": 0,
            "Tue": 0,
            "Wed": 0,
            "Thu": 0,
            "Fri": 0,
            "Sat": 0,
            "Sun": 0
        ]
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Setting the first weekday to Monday (1 = Sunday, 2 = Monday)
        
        for instance in instances {
            if let instanceDate = instance.date {
                // Get the weekday, ensuring that it is relative to Monday as the first day
                let weekday = calendar.component(.weekday, from: instanceDate)
                
                // Adjust the weekday to be zero-indexed starting from Monday
                // The result will be an index from 0 (Monday) to 6 (Sunday)
                let adjustedWeekday = (weekday + 5) % 7
                
                // Map the adjusted weekday to the corresponding day name
                let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                let weekdayString = weekdays[adjustedWeekday]
                
                // Increment the count for the corresponding day
                dayOfWeekCounts[weekdayString, default: 0] += 1
            }
        }
        
        return dayOfWeekCounts
    }
    
    private func calculateSessionsPerMonth() -> [String: Int] {
        var monthlySessions: [String: Int] = [:]
        let calendar = Calendar.current
        let currentDate = Date()

        // Generate the last 6 months with "MMMM yyyy" format to include year
        for i in 0..<6 {
            if let monthDate = calendar.date(byAdding: .month, value: -i, to: currentDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"  // Include year in the format
                let monthString = dateFormatter.string(from: monthDate)
                monthlySessions[monthString] = 0
            }
        }

        // Count the number of instances (sessions) and assign them to the corresponding month/year
        for instance in instances {
            if let instanceDate = instance.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"  // Ensure the same format for month/year
                let monthString = dateFormatter.string(from: instanceDate)

                if monthlySessions[monthString] != nil {
                    monthlySessions[monthString]! += 1  // Increment the session count
                }
            }
        }

        return monthlySessions
    }
        
        private func calculateTotalWeight() -> Double {
                var totalWeight: Double = 0.0

                for instance in instances {
                    if let logs = instance.log as? Set<Log> {
                        for log in logs {
                            totalWeight += log.weight * Double(log.reps)
                        }
                    }
                }

                return totalWeight
            }

            // Function to calculate the total number of sets
            private func calculateTotalSets() -> Int {
                var totalSets = 0

                for instance in instances {
                    if let logs = instance.log as? Set<Log> {
                        totalSets += logs.count
                    }
                }

                return totalSets
            }

            // Function to calculate the total number of reps
            private func calculateTotalReps() -> Int {
                var totalReps = 0

                for instance in instances {
                    if let logs = instance.log as? Set<Log> {
                        for log in logs {
                            totalReps += Int(log.reps)
                        }
                    }
                }

                return totalReps
            }
    enum TimeRange {
        case oneYear
        case twoYears
        case threeYears
        case fromFirstSession
    }
    // Calculate total duration of all training instances
    private func calculateTotalDuration() -> TimeInterval {
        var totalDuration: TimeInterval = 0
        
        for instance in instances {
            if let start = instance.trainingstart, let end = instance.trainingend {
                totalDuration += end.timeIntervalSince(start)
            }
        }
        
        return totalDuration
    }

    // Calculate total duration of sessions this month
    private func calculateTotalDurationThisMonth() -> TimeInterval {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        var totalDuration: TimeInterval = 0
        
        for instance in instances {
            if let start = instance.trainingstart, let end = instance.trainingend {
                if calendar.component(.month, from: start) == currentMonth {
                    totalDuration += end.timeIntervalSince(start)
                }
            }
        }
        
        return totalDuration
    }

    // Calculate total duration of sessions this year
    private func calculateTotalDurationThisYear() -> TimeInterval {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var totalDuration: TimeInterval = 0
        
        for instance in instances {
            if let start = instance.trainingstart, let end = instance.trainingend {
                if calendar.component(.year, from: start) == currentYear {
                    totalDuration += end.timeIntervalSince(start)
                }
            }
        }
        
        return totalDuration
    }

    // Calculate average duration per training instance
    private func calculateAverageDurationPerInstance() -> Double {
        let totalDuration = calculateTotalDuration()
        
        // Avoid division by zero
        if instances.isEmpty {
            return 0
        }
        
        return totalDuration / Double(instances.count) / 60  // Convert to minutes
    }

    // Format the duration in "dd hh mm" format
    private func formatTotalDuration(_ duration: TimeInterval) -> String {
        let days = Int(duration) / 86400
        let hours = (Int(duration) % 86400) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if days > 0 {
            return "\(days)d \(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    // Format duration in minutes
    private func formatMinutes(_ minutes: Double) -> String {
        return String(format: "%.2f", minutes)
    }
}
struct InstancesForSelectedDateView: View {
    let selectedDate: Date
    let instances: [TrainingInstance]
    @EnvironmentObject var colorSettings: ColorSettings

    var filteredInstances: [TrainingInstance] {
        let calendar = Calendar.current
        return instances.filter {
            guard let instanceDate = $0.date else { return false }
            return calendar.isDate(instanceDate, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        VStack {
            
            
            if filteredInstances.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                HStack {
                    
                    Text("\(formatDateToDateOrFullDayName(date: selectedDate))")
                        .customFont(.semiBold, 16)
                        .foregroundStyle(.primary)
                        .padding(5)
                        .frame(width: 100)
                    
                    Text("No Sessions for this Date")
                        .customFont(.light, 14)
                        
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
                .padding()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    
                    ForEach(filteredInstances, id: \.self) { log in
                        NavigationLink(destination: InstanceLogView(trainingInstanceID: .constant(log.id ?? UUID()))) {
                            HStack {
                                Text("\(formatDateToDateOrFullDayName(date: selectedDate))")
                                    .customFont(.medium, 15)
                                    .foregroundColor(.primary)
                                    .padding(5)
                                    .padding(.trailing)
                                    .frame(width: 110)
                                
                                VStack(alignment: .leading) {
                                    Text("\(log.training?.name ?? "-")")
                                        .customFont(.medium, 16)
                                        .foregroundColor(log.training == nil ? .red : .primary)
                                    
                                    // Get the total number of exercises and completed exercises
                                    let totalSets = log.training?.trainingTexercise?.count ?? 0
                                    let completedSets = log.log?.count ?? 0
                                    
                                    HStack {
                                        // Show "X/Y Exercises done"
                                        Text("\(completedSets)/\(totalSets) Sets done")
                                            .customFont(.regular, 12)
                                            .foregroundColor(.gray)
                                        
                                        Text("-")
                                            .customFont(.regular, 12)
                                            .foregroundStyle(.gray)
                                        
                                        // Show the start and end time of the training
                                        
                                    }
                                    if let start = log.trainingstart, let end = log.trainingend {
                                        HStack (spacing: 2){
                                            Text("\(formatTime(date: start)) - \(formatTime(date: end))")
                                                .customFont(.medium, 12)
                                                .foregroundColor(.primary)
                                            Text("-")
                                                .customFont(.medium, 12)
                                                .foregroundStyle(.gray)
                                            Text(formatDuration(start: log.trainingstart ?? Date(), end: log.trainingend ?? Date()))
                                                .customFont(.medium, 12)
                                                .foregroundStyle(colorSettings.selectedColor)
                                        }
                                    }
                                    
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .frame(height: 700)
        .onAppear {
            // Debugging to check the filtered instances
            print("Selected Date: \(selectedDate)")
            print("Filtered Instances Count: \(filteredInstances.count)")
            filteredInstances.forEach { instance in
                print("Instance: \(instance)")
            }
        }
    }

    private func formatDuration(start: Date, end: Date) -> String {
        let duration = end.timeIntervalSince(start)
        let minutes = Int(duration) / 60
        
        // Check for singular or plural form of "minute"
        return minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes"
    }
    
    
}

struct YearMonth: Hashable, Comparable {
    let year: Int
    let month: Int
    
    // Conform to Comparable to allow sorting
    static func < (lhs: YearMonth, rhs: YearMonth) -> Bool {
        if lhs.year == rhs.year {
            return lhs.month > rhs.month
        }
        return lhs.year > rhs.year
    }
}

extension AnyTransition {
    static var slideFromLeft: AnyTransition {
        .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    }

    static var slideFromRight: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
}

