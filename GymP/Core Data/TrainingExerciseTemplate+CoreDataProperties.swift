//
//  TrainingExerciseTemplate+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 07.02.25.
//
//

import Foundation
import CoreData


extension TrainingExerciseTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingExerciseTemplate> {
        return NSFetchRequest<TrainingExerciseTemplate>(entityName: "TrainingExerciseTemplate")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var index: Int16
    @NSManaged public var isExtraSet: Bool
    @NSManaged public var isLogged: Bool
    @NSManaged public var isWarmup: Bool
    @NSManaged public var reps: Int32
    @NSManaged public var temporarLogID: UUID?
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?
    @NSManaged public var log: NSOrderedSet?
    @NSManaged public var training: Training?

}

// MARK: Generated accessors for log
extension TrainingExerciseTemplate {

    @objc(insertObject:inLogAtIndex:)
    @NSManaged public func insertIntoLog(_ value: Log, at idx: Int)

    @objc(removeObjectFromLogAtIndex:)
    @NSManaged public func removeFromLog(at idx: Int)

    @objc(insertLog:atIndexes:)
    @NSManaged public func insertIntoLog(_ values: [Log], at indexes: NSIndexSet)

    @objc(removeLogAtIndexes:)
    @NSManaged public func removeFromLog(at indexes: NSIndexSet)

    @objc(replaceObjectInLogAtIndex:withObject:)
    @NSManaged public func replaceLog(at idx: Int, with value: Log)

    @objc(replaceLogAtIndexes:withLog:)
    @NSManaged public func replaceLog(at indexes: NSIndexSet, with values: [Log])

    @objc(addLogObject:)
    @NSManaged public func addToLog(_ value: Log)

    @objc(removeLogObject:)
    @NSManaged public func removeFromLog(_ value: Log)

    @objc(addLog:)
    @NSManaged public func addToLog(_ values: NSOrderedSet)

    @objc(removeLog:)
    @NSManaged public func removeFromLog(_ values: NSOrderedSet)

}

extension TrainingExerciseTemplate : Identifiable {

}
