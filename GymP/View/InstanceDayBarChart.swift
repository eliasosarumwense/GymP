//
//  InstanceDayBarChart.swift
//  GymP
//
//  Created by Elias Osarumwense on 23.08.24.
//

import SwiftUI
import Charts

struct InstanceDayBarChart: View {
    @EnvironmentObject var colorSettings: ColorSettings
    let dayOfWeekCounts: [String: Int]
    
    var body: some View {
        Chart {
            ForEach(Array(dayOfWeekCounts.sorted(by: { dayIndex(for: $0.key) < dayIndex(for: $1.key) })), id: \.key) { day, count in
                BarMark(
                    x: .value("Day", day),
                    y: .value("Count", count)
                )
                .foregroundStyle(colorSettings.selectedColor)
            }
        }
        .frame(width: 160, height: 120)      // Adjust the width and height of the chart
        .chartXAxis {                        // Customize the x-axis
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .font(.customFont(.light, 8))         // Smaller font for x-axis labels
            }
        }
        .chartYAxis {                        // Customize the x-axis
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .font(.customFont(.light, 8))         // Smaller font for x-axis labels
            }
        }
        .padding(.horizontal)
    }
    
    // Helper function to map day names to indices for correct sorting
    private func dayIndex(for day: String) -> Int {
        switch day {
        case "Mon": return 0
        case "Tue": return 1
        case "Wed": return 2
        case "Thu": return 3
        case "Fri": return 4
        case "Sat": return 5
        case "Sun": return 6
        default: return 7
        }
    }
}

