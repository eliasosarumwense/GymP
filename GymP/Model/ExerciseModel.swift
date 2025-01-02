//
//  ExerciseModel.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import Foundation

struct ExerciseDummy: Identifiable, Hashable, Decodable {
    let id: Int
    let name: String
    let descrip: String
    var muscle: [MuscleDummy]
    var equipment: [EquipmentDummy]
}

struct MuscleDummy: Identifiable, Hashable, Decodable {
    let id: Int
    let name: String
}

struct EquipmentDummy: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
}

let stockexercises: [ExerciseDummy] = [
    ExerciseDummy(id: 1, name: "Benchpress", descrip: "short description", muscle: [MuscleDummy(id: 1, name: "Chestmuscle")], equipment: [EquipmentDummy(id: "1", name: "Flat bank")])
]

let muscles = ["Chest", "Shoulder", "Bizeps", "Triceps"]
