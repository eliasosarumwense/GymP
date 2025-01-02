//
//  DateSelectionSheet.swift
//  GymP
//
//  Created by Elias Osarumwense on 02.08.24.
//

import SwiftUI

struct DateSelectionSheet: View {
    @Binding var useDatePickers: Bool
    @Binding var customStartDate: Date
    @Binding var customEndDate: Date
    @Binding var selectedDays: Int
    @Binding var showDatePickerSheet: Bool
    @Binding var timeScale: DemoChart.TimeScale

    var body: some View {
        VStack {
            Toggle("Daypicker / Datepicker:", isOn: $useDatePickers)
                .toggleStyle(CustomToggle())
                .font(.customFont(.medium, 17))
                .onChange(of: useDatePickers) { newValue in
                    if newValue {
                        selectedDays = 7
                    } else {
                        customStartDate = changeHourOfDate(to: 0, minute: 0, from: Date()) ?? Date()
                        customEndDate = changeHourOfDate(to: 0, minute: 0, from: Date()) ?? Date()
                    }
                }
            Spacer()
            if useDatePickers {
                DatePicker("Starting Date:", selection: $customStartDate, displayedComponents: .date)
                    .font(.customFont(.regular, 18))
                    .onChange(of: customStartDate) { newDate in
                        customStartDate = changeHourOfDate(to: 0, minute: 0, from: newDate) ?? newDate
                    }
                DatePicker("Ending Date:", selection: $customEndDate, displayedComponents: .date)
                    .font(.customFont(.regular, 18))
                    .onChange(of: customEndDate) { newDate in
                        customEndDate = changeHourOfDate(to: 0, minute: 0, from: newDate) ?? newDate
                    }
            } else {
                Picker("Select Days Back", selection: $selectedDays) {
                    ForEach(1..<366) { day in
                        Text("\(day) days").tag(day)
                    }
                }
                .font(.customFont(.medium, 18))
                .pickerStyle(WheelPickerStyle())
            }
            
            Button("Apply") {
                withAnimation {
                    if useDatePickers {
                        customStartDate = changeHourOfDate(to: 0, minute: 0, from: customStartDate) ?? customStartDate
                        customEndDate = changeHourOfDate(to: 0, minute: 0, from: customEndDate) ?? customEndDate
                        timeScale = .custom
                    } else {
                        customStartDate = changeHourOfDate(to: 0, minute: 0, from: Calendar.current.date(byAdding: .day, value: -selectedDays, to: Date())!) ?? Date()
                        customEndDate = changeHourOfDate(to: 0, minute: 0, from: Date()) ?? Date()
                        timeScale = .custom
                    }
                    showDatePickerSheet = false
                }
            }
            .font(.customFont(.semiBold, 15))
            .foregroundColor(.orange)
            .padding()
        }
        .presentationDetents([.height(300)])
        .padding()
    }
    
    private func changeHourOfDate(to hour: Int, minute: Int, from date: Date) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = hour
        components.minute = minute
        components.second = 0
        
        return calendar.date(from: components)
    }
}

