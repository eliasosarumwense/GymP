//
//  Permanent Data.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import Foundation

let todolist: [TodoDummy] = [
    TodoDummy(id: 1, title: "Buy groceries", date: createDate(year: 2023, month: 7, day: 20, hour: 9, minute: 0), status: .pending),
        TodoDummy(id: 2, title: "Finish homework", date: createDate(year: 2023, month: 7, day: 21, hour: 15, minute: 30), status: .pending),
        TodoDummy(id: 3, title: "Call mom", date: createDate(year: 2023, month: 7, day: 22, hour: 12, minute: 0), status: .pending),
        TodoDummy(id: 4, title: "Go for a run", date: createDate(year: 2023, month: 7, day: 23, hour: 7, minute: 0), status: .pending),
        TodoDummy(id: 5, title: "Read a book", date: createDate(year: 2023, month: 7, day: 19, hour: 18, minute: 0), status: .completed),
        TodoDummy(id: 6, title: "Write a blog post", date: createDate(year: 2023, month: 7, day: 18, hour: 20, minute: 0), status: .completed),
        TodoDummy(id: 7, title: "Attend a meeting", date: createDate(year: 2023, month: 7, day: 25, hour: 10, minute: 0), status: .pending),
        TodoDummy(id: 8, title: "Clean the house", date: createDate(year: 2023, month: 7, day: 17, hour: 14, minute: 0), status: .completed),
        TodoDummy(id: 9, title: "Practice playing guitar", date: createDate(year: 2023, month: 7, day: 26, hour: 16, minute: 0), status: .pending),
        TodoDummy(id: 10, title: "Plan a trip", date: createDate(year: 2023, month: 7, day: 27, hour: 11, minute: 30), status: .pending)
]
