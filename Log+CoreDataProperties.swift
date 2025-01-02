//
//  Log+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var reps: Int32
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?
    @NSManaged public var training: Training?
    @NSManaged public var trainingInstance: TrainingInstance?
    @NSManaged public var trainingTemplate: TrainingExerciseTemplate?

}

extension Log : Identifiable {

}
