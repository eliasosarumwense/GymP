//
//  Dates.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import Foundation

func formatDateToDateAndHours(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" // Use 'HH' for 24-hour format, 'hh' for 12-hour format
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

func formatDateToDateOnly(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yy" // Use 'HH' for 24-hour format, 'hh' for 12-hour format
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

func formatDateToDateOrFullDayName(date: Date) -> String {
    let calendar = Calendar.current
        let currentDate = Date()
        
        // Calculate the date 1 week ago from today
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: currentDate) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        
        // If the date is within the last 7 days, return the full day name
        if date >= oneWeekAgo {
            dateFormatter.dateFormat = "EEEE" // Full day name (e.g., "Monday")
        } else {
            dateFormatter.dateFormat = "dd.MM.yy" // Default date format
        }
        
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
}

func formatDateToHoursAndMinutes(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

func formatDuration(start: Date, end: Date) -> String {
    let duration = end.timeIntervalSince(start)
    let minutes = Int(duration / 60)
    if minutes < 60 {
        return "\(minutes) minutes"
    } else {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%02d:%02d", hours, remainingMinutes)
    }
}

func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}
