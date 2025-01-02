//
//  Todo.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import Foundation

enum TodoStatus: String, CaseIterable, Decodable {
    case pending
    case completed
}

struct TodoDummy: Identifiable, Hashable, Decodable {
    let id: Int
    let title: String
    let date: Date
    var status: TodoStatus
}

// Helper function to create Date instances from components
func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = TimeZone.current
    let calendar = Calendar.current
    return calendar.date(from: components)!
}

// Sample data
let todos: [TodoDummy] = [
    TodoDummy(id: 1, title: "Buy groceries", date: createDate(year: 2023, month: 7, day: 20, hour: 9, minute: 0), status: .pending),
    TodoDummy(id: 2, title: "Finish homework", date: createDate(year: 2023, month: 7, day: 21, hour: 15, minute: 30), status: .pending),
    TodoDummy(id: 3, title: "Call mom", date: createDate(year: 2023, month: 7, day: 22, hour: 12, minute: 0), status: .pending),

]
