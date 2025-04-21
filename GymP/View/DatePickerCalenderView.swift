//
//  TestValender.swift
//  GymP
//
//  Created by Elias Osarumwense on 24.08.24.
//
import SwiftUI

struct CustomCompactDatePickerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var colorSettings: ColorSettings
    @Binding var selectedDate: Date
    @State private var currentMonth: Date = Date()
    @State private var showingPicker: Bool = false  // Track whether the month-year picker is shown

    var instances: [TrainingInstance] = []
    
    var body: some View {
        VStack {
            // Custom Compact Calendar UI
            VStack {
                // HStack with Month/Year and Arrows - Fixed in place
                HStack {
                    Button(action: {
                        withAnimation {
                            showingPicker.toggle()
                        }
                    }) {
                        HStack {
                            Text(currentMonthAndYear())
                                .customFont(.semiBold, 16)
                            Image(systemName: showingPicker ? "chevron.down" : "chevron.right")
                                .foregroundStyle(colorSettings.selectedColor)
                        }
                    }
                    .accentColor(.primary)
                    .padding(.horizontal, 0)
                    
                    Spacer()

                    // Arrows always visible, regardless of what's displayed
                    HStack {
                        Button(action: {
                            changeMonth(by: -1)
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundStyle(colorSettings.selectedColor)
                        }
                        .padding(.horizontal, 25)

                        Button(action: {
                            changeMonth(by: 1)
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundStyle(colorSettings.selectedColor)
                        }
                        .padding(.horizontal, 6)
                    }
                }
                .frame(width: 320)
                .padding(15)

                // Toggle between the Month/Year picker and the Calendar, content below the fixed HStack
                if showingPicker {
                    MonthYearPickerView(currentMonth: $currentMonth)
                        .padding(.horizontal, 10)
                    Spacer()
                } else {
                    CalendarView(selectedDate: $selectedDate, currentMonth: $currentMonth, instances: instances) // Pass instances
                                            .padding(.horizontal, 10)
                                        Spacer()
                }
            }
            .frame(width: 360, height: 360)
            .background(colorScheme == .dark ? Color(.darkGray).opacity(0.3) : Color(.gray).opacity(0.2))
            .cornerRadius(15)
            //.padding()
            //Spacer()
        }
    }

    private func changeMonth(by offset: Int) {
        let newMonth = Calendar.current.date(byAdding: .month, value: offset, to: currentMonth) ?? currentMonth
        withAnimation(.smooth(duration: 0.3)) {
            currentMonth = newMonth
        }
    }

    private func currentMonthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
}

struct CalendarView: View {
    
    @EnvironmentObject var colorSettings: ColorSettings
    @Binding var selectedDate: Date
    @Binding var currentMonth: Date

    let rowHeight: CGFloat = 40
    let rowSpacing: CGFloat = 5
    let headerHeight: CGFloat = 20
    let rectangleHeight: CGFloat = 40
    let rectangleWidth: CGFloat = 360
    
    let instances: [TrainingInstance]

    @Namespace private var animationNamespace

    var body: some View {
        VStack(spacing: rowSpacing) {
            let daysOfTheWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            // Days of the Week Header
            HStack(spacing: 0) {
                ForEach(daysOfTheWeek, id: \.self) { day in
                    Text(day)
                        .customFont(.semiBold, 12)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: headerHeight)

            ZStack {
                let calendar = Calendar.current
                let currentDate = Date()
                let isCurrentMonthDisplayed = calendar.isDate(currentDate, equalTo: currentMonth, toGranularity: .month)

                // Show the rectangle only if the current month is being displayed
                if isCurrentMonthDisplayed {
                                    Rectangle()
                                        .fill(colorSettings.selectedColor.opacity(0.2))
                                        .cornerRadius(50)
                                        .frame(width: rectangleWidth, height: rowHeight)
                                        .position(x: 350 / 2, y: getRectangleYPosition() - 20) // Centered in the middle of the view
                                        //.animation(.easeInOut, value: selectedDate)
                                        
                                }
                
                
                // LazyVGrid for Calendar Days
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: rowSpacing) {
                    ForEach(generateMonthDates(), id: \.self) { dateData in
                        dateCell(dateData: dateData)
                            .frame(height: rowHeight)
                            .onTapGesture {
                                if dateData.isCurrentMonth {
                                    withAnimation(.easeInOut   ) {
                                        selectedDate = dateData.date
                                    }
                                }
                            }
                    }
                }
            }
            .frame(height: calculateGridHeight()) // Set a fixed height for the ZStack
        }
        .frame(width: 350)
    }

    private func calculateGridHeight() -> CGFloat {
        let rowCount = (generateMonthDates().count / 7)
        return CGFloat(rowCount) * rowHeight + CGFloat(rowCount - 1) * rowSpacing
    }

    private struct DateData: Hashable {
        var date: Date
        var isCurrentMonth: Bool
    }

    private func generateMonthDates() -> [DateData] {
        let calendar = Calendar.current
        var dates: [DateData] = []

        // Get the first day of the current month
        var calendarWithTimeZone = calendar
            calendarWithTimeZone.timeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone.current

            // Get the first day of the current month in a time-zone neutral way
            guard let startOfMonth = calendarWithTimeZone.date(from: calendarWithTimeZone.dateComponents([.year, .month], from: currentMonth)) else {
                return dates
            }

        // Get the range of days in the current month
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!

        // Find the weekday of the first day of the month
        let firstDayOfMonthWeekday = calendar.component(.weekday, from: startOfMonth)

        // Calculate how many padding days from the previous month are needed
        let paddingDaysBefore = (firstDayOfMonthWeekday - calendar.firstWeekday + 7) % 7

        // Add padding days from the previous month
        if paddingDaysBefore > 0 {
            guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth),
                  let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth),
                  let previousMonthLastDay = calendar.date(byAdding: .day, value: -1, to: startOfMonth) else {
                return dates
            }

            let previousMonthStartDay = calendar.component(.day, from: previousMonthLastDay)
            for i in 0..<paddingDaysBefore {
                if let date = calendar.date(byAdding: .day, value: -(paddingDaysBefore - i), to: startOfMonth) {
                    dates.append(DateData(date: date, isCurrentMonth: false))
                }
            }
        }

        // Add the current month's days
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(DateData(date: date, isCurrentMonth: true))
            }
        }

        // Calculate how many padding days are needed from the next month to fill the grid
        let totalDaysCount = dates.count
        let paddingDaysAfter = (7 - (totalDaysCount % 7)) % 7

        // Add padding days from the next month
        if paddingDaysAfter > 0 {
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth),
                  let nextMonthStartDay = calendar.date(bySetting: .day, value: 1, of: nextMonth) else {
                return dates
            }

            for i in 0..<paddingDaysAfter {
                if let date = calendar.date(byAdding: .day, value: i, to: nextMonthStartDay) {
                    dates.append(DateData(date: date, isCurrentMonth: false))
                }
            }
        }

        return dates
    }

    @ViewBuilder
    private func dateCell(dateData: DateData) -> some View {
        VStack {
            ZStack {
                // Highlight today's date
                if Calendar.current.isDateInToday(dateData.date) {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 45, height: 45)
                }
                
                // Highlight the selected date
                if Calendar.current.isDate(selectedDate, inSameDayAs: dateData.date) {
                    Circle()
                        .fill(dateData.isCurrentMonth ? colorSettings.selectedColor.opacity(0.8) : colorSettings.selectedColor.opacity(0.3))
                        .frame(width: 45, height: 45)
                        //.transition(.scale)
                        //.animation(.easeInOut(duration: 0.3), value: selectedDate)
                }
                
                // Display the date number
                Text(dayString(from: dateData.date))
                    .customFont(Calendar.current.isDate(selectedDate, inSameDayAs: dateData.date) ? .medium : .regular, Calendar.current.isDate(selectedDate, inSameDayAs: dateData.date) ? 18 : 17)
                    .foregroundColor(Calendar.current.isDate(selectedDate, inSameDayAs: dateData.date) ? .white : .primary)
                    .opacity(dateData.isCurrentMonth ? 1.0 : 0.3)
                
                // Display a red dot if there's an instance for this date, but only for the current month
                if hasInstance(on: dateData.date, isCurrentMonth: dateData.isCurrentMonth) {
                    HStack(spacing: 1) {
                        Spacer()
                        Image(systemName: "circle.fill")
                            .font(.system(size: 4))
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .offset(y: 14)
                }
            }
            .frame(width: 60, height: 60) // Increased frame size for better tap area
            .contentShape(Rectangle()) // Make the whole frame tappable
            .onTapGesture {
                withAnimation(.linear(duration: 0.2)) {
                    selectedDate = dateData.date
                }
            }
        }
    }


    private func hasInstance(on date: Date, isCurrentMonth: Bool) -> Bool {
        // Only check for instances on dates that belong to the current month
        guard isCurrentMonth else { return false }
        
        let calendar = Calendar.current

        // Normalize the target date by stripping time components
        let targetDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard let targetDate = calendar.date(from: targetDateComponents) else { return false }

        print("Checking normalized target date: \(targetDate)")

        for instance in instances {
            if let instanceDate = instance.date {
                // Normalize the instance date similarly by stripping time components
                let instanceDateComponents = calendar.dateComponents([.year, .month, .day], from: instanceDate)
                guard let normalizedInstanceDate = calendar.date(from: instanceDateComponents) else { continue }

                print("Comparing with normalized instance date: \(normalizedInstanceDate)")

                // Compare the dates purely on the year, month, and day
                if targetDate == normalizedInstanceDate {
                    print("Match found for date: \(date)")
                    return true
                }
            }
        }

        print("No match for date: \(date)")
        return false
    }

    private func getRectangleYPosition() -> CGFloat {
        let calendar = Calendar.current
        let currentWeekRange = currentWeekRange()
        let dates = generateMonthDates() // Get all dates, including padding from previous and next months

        // Check if the current week is within the current month
        let weekStartIsInCurrentMonth = calendar.isDate(currentWeekRange.start, equalTo: currentMonth, toGranularity: .month)
        let weekEndIsInCurrentMonth = calendar.isDate(currentWeekRange.end, equalTo: currentMonth, toGranularity: .month)
        
        // Only proceed if either the start or end of the week is within the current month
        guard weekStartIsInCurrentMonth || weekEndIsInCurrentMonth else {
            return 0 // Return 0 if the current week doesn't intersect with the current month
        }

        // Find the index of the start of the current week, ensuring we search across all months
        guard let indexOfWeekStart = dates.firstIndex(where: {
            calendar.isDate($0.date, inSameDayAs: currentWeekRange.start) || calendar.isDate($0.date, inSameDayAs: currentWeekRange.end)
        }) else {
            return 0 // Fallback if the start of the week is not found
        }

        // Calculate the row index based on the week start index (7 days per row)
        let rowIndex = CGFloat(indexOfWeekStart / 7)

        // Calculate the Y offset based on the row index, row height, and row spacing
        let offsetY = rowIndex * (rowHeight + rowSpacing) + (rowHeight / 2) + headerHeight

        return offsetY
    }

    private func currentWeekRange() -> (start: Date, end: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()

        // Force the calendar to use Monday as the start of the week
        let weekdayComponents = calendar.dateComponents([.weekday], from: today)
        let daysToMonday = (weekdayComponents.weekday! + 5) % 7 // Calculate days to the most recent Monday

        // Get the start of the week (Monday)
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysToMonday, to: today) else {
            return (start: today, end: today) // Fallback if the calculation fails
        }

        // Get the end of the week (Sunday)
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
            return (start: startOfWeek, end: startOfWeek) // Fallback if the calculation fails
        }

        return (start: startOfWeek, end: endOfWeek)
    }

    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct MonthYearPickerView: View {
    @Binding var currentMonth: Date

    @State private var selectedMonth: Int = 0  // Track selected month (0-based)
    @State private var selectedYear: Int = 0    // Track selected year

    let months = Calendar.current.monthSymbols
    let years = Array(2000...2100)  // Adjust range as needed

    var body: some View {
        HStack {
            // Month picker
            Picker("Month", selection: $selectedMonth) {
                ForEach(0..<12) { index in
                    Text(months[index]).tag(index)
                }
            }
            .labelsHidden()
            .frame(width: 150)
            .clipped()

            // Year picker
            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text(String(year)).tag(year)
                }
            }
            .labelsHidden()
            .frame(width: 80)
            .clipped()
        }
        .pickerStyle(WheelPickerStyle())
        .onChange(of: selectedMonth) { _ in
            updateDate()
        }
        .onChange(of: selectedYear) { _ in
            updateDate()
        }
        .onAppear {
            // Sync selectedMonth and selectedYear with the currentMonth
            let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
            selectedMonth = (components.month ?? 1) - 1  // Convert 1-based to 0-based index
            selectedYear = components.year ?? selectedYear
        }
    }

    private func updateDate() {
        // Ensure the selectedMonth and selectedYear correctly set the currentMonth
        let newDateComponents = DateComponents(year: selectedYear, month: selectedMonth + 1)  // Convert back to 1-based month
        if let newDate = Calendar.current.date(from: newDateComponents) {
            currentMonth = newDate
        }
    }
}


// Preview
struct CustomCompactDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        let colorSettings = ColorSettings()

        // Mock instances for the preview
        let mockInstances: [TrainingInstance] = [

        ]

        CustomCompactDatePickerView(selectedDate: .constant(Date()), instances: mockInstances)  // Provide the selected date and mock instances
            .environmentObject(colorSettings)  // Inject environment objects
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
