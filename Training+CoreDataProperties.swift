//
//  Training+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 07.02.25.
//
//

import Foundation
import CoreData


extension Training {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Training> {
        return NSFetchRequest<Training>(entityName: "Training")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var exerciseT: NSSet?
    @NSManaged public var log: NSSet?
    @NSManaged public var trainingInstance: NSSet?
    @NSManaged public var trainingRoutine: TrainingRoutine?
    @NSManaged public var trainingTexercise: NSSet?
    @NSManaged public var routineSchedule: NSSet?

}

// MARK: Generated accessors for exerciseT
extension Training {

    @objc(addExerciseTObject:)
    @NSManaged public func addToExerciseT(_ value: Exercise)

    @objc(removeExerciseTObject:)
    @NSManaged public func removeFromExerciseT(_ value: Exercise)

    @objc(addExerciseT:)
    @NSManaged public func addToExerciseT(_ values: NSSet)

    @objc(removeExerciseT:)
    @NSManaged public func removeFromExerciseT(_ values: NSSet)

}

// MARK: Generated accessors for log
extension Training {

    @objc(addLogObject:)
    @NSManaged public func addToLog(_ value: Log)

    @objc(removeLogObject:)
    @NSManaged public func removeFromLog(_ value: Log)

    @objc(addLog:)
    @NSManaged public func addToLog(_ values: NSSet)

    @objc(removeLog:)
    @NSManaged public func removeFromLog(_ values: NSSet)

}

// MARK: Generated accessors for trainingInstance
extension Training {

    @objc(addTrainingInstanceObject:)
    @NSManaged public func addToTrainingInstance(_ value: TrainingInstance)

    @objc(removeTrainingInstanceObject:)
    @NSManaged public func removeFromTrainingInstance(_ value: TrainingInstance)

    @objc(addTrainingInstance:)
    @NSManaged public func addToTrainingInstance(_ values: NSSet)

    @objc(removeTrainingInstance:)
    @NSManaged public func removeFromTrainingInstance(_ values: NSSet)

}

// MARK: Generated accessors for trainingTexercise
extension Training {

    @objc(addTrainingTexerciseObject:)
    @NSManaged public func addToTrainingTexercise(_ value: TrainingExerciseTemplate)

    @objc(removeTrainingTexerciseObject:)
    @NSManaged public func removeFromTrainingTexercise(_ value: TrainingExerciseTemplate)

    @objc(addTrainingTexercise:)
    @NSManaged public func addToTrainingTexercise(_ values: NSSet)

    @objc(removeTrainingTexercise:)
    @NSManaged public func removeFromTrainingTexercise(_ values: NSSet)

}

// MARK: Generated accessors for routineSchedule
extension Training {

    @objc(addRoutineScheduleObject:)
    @NSManaged public func addToRoutineSchedule(_ value: TrainingSchedule)

    @objc(removeRoutineScheduleObject:)
    @NSManaged public func removeFromRoutineSchedule(_ value: TrainingSchedule)

    @objc(addRoutineSchedule:)
    @NSManaged public func addToRoutineSchedule(_ values: NSSet)

    @objc(removeRoutineSchedule:)
    @NSManaged public func removeFromRoutineSchedule(_ values: NSSet)

}

extension Training : Identifiable {

}
