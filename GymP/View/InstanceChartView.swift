//
//  InstanceChartView.swift
//  GymP
//
//  Created by Elias Osarumwense on 25.08.24.
//

import SwiftUI

struct InstanceChartView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @FetchRequest(
        entity: TrainingInstance.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingInstance.date, ascending: false)]
    ) private var instances: FetchedResults<TrainingInstance>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Text("Total Sessions each day")
                        .customFont(.medium, 13)
                        .padding(5)
                    InstanceDayBarChart(dayOfWeekCounts: calculateInstancesPerDayOfWeek())
                }
                Spacer()
                VStack {
                    Text("Total Sessions each Month (6 Months)")
                        .customFont(.medium, 13)
                        .padding(5)
                    InstanceSixMonthBarChart(monthlySets: calculateSessionsPerMonth())
                        .environmentObject(colorSettings)
                }
            }
        }
        .padding()
    }
    
    private func calculateInstancesPerDayOfWeek() -> [String: Int] {
        var dayOfWeekCounts: [String: Int] = [
            "Mon": 0, "Tue": 0, "Wed": 0, "Thu": 0, "Fri": 0, "Sat": 0, "Sun": 0
        ]
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday as the first day of the week
        
        for instance in instances {
            if let instanceDate = instance.date {
                let weekday = calendar.component(.weekday, from: instanceDate)
                let adjustedWeekday = (weekday + 5) % 7
                let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                let weekdayString = weekdays[adjustedWeekday]
                dayOfWeekCounts[weekdayString, default: 0] += 1
            }
        }
        
        return dayOfWeekCounts
    }

    private func calculateSessionsPerMonth() -> [String: Int] {
        var monthlySessions: [String: Int] = [:]
        let calendar = Calendar.current
        let currentDate = Date()
        
        for i in 0..<6 {
            if let monthDate = calendar.date(byAdding: .month, value: -i, to: currentDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                let monthString = dateFormatter.string(from: monthDate)
                monthlySessions[monthString] = 0
            }
        }

        for instance in instances {
            if let instanceDate = instance.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                let monthString = dateFormatter.string(from: instanceDate)
                
                if monthlySessions[monthString] != nil {
                    monthlySessions[monthString]! += 1
                }
            }
        }

        return monthlySessions
    }
}

