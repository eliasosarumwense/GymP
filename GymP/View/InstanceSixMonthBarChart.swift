//
//  InstanceMonthBarChart.swift
//  GymP
//
//  Created by Elias Osarumwense on 23.08.24.
//

import SwiftUI
import Charts

struct InstanceSixMonthBarChart: View {
    @EnvironmentObject var colorSettings: ColorSettings
    let monthlySets: [String: Int]  // Pass the number of sets per month
    
    var body: some View {
        Chart {
            ForEach(Array(monthlySets.sorted(by: { monthIndex(for: $0.key) < monthIndex(for: $1.key) })), id: \.key) { month, count in
                BarMark(
                    x: .value("Month", month),
                    y: .value("Count", count)
                )
                .foregroundStyle(colorSettings.selectedColor)
            }
        }
        .frame(width: 160, height: 120)  // Adjust the height of the chart
        .chartXAxis {        // Customize the x-axis
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .font(.customFont(.light, 8))  // Smaller font for x-axis labels
            }
        }
        .chartYAxis {        // Customize the y-axis
            AxisMarks { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .font(.customFont(.light, 8))  // Smaller font for y-axis labels
            }
        }
        .padding(.horizontal)
    }
    
    // Helper function to map month names to indices for correct sorting
    private func monthIndex(for month: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        if let date = dateFormatter.date(from: month) {
            let calendar = Calendar.current
            return calendar.component(.month, from: date) - 1
        }
        return 0
    }
}
