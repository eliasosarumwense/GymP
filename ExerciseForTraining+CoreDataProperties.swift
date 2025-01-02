//
//  ExerciseForTraining+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//
//

import Foundation
import CoreData


extension ExerciseForTraining {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseForTraining> {
        return NSFetchRequest<ExerciseForTraining>(entityName: "ExerciseForTraining")
    }

    @NSManaged public var doIndex: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var reps: String?
    @NSManaged public var weight: String?
    @NSManaged public var exercise: Exercise?

}

extension ExerciseForTraining : Identifiable {

}
