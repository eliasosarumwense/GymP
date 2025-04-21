//
//  Exercise+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 07.02.25.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var descrip: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var equipment: NSOrderedSet?
    @NSManaged public var log: NSOrderedSet?
    @NSManaged public var muscle: NSOrderedSet?
    @NSManaged public var trainingEtemplate: NSSet?
    @NSManaged public var trainings: NSSet?

}

// MARK: Generated accessors for equipment
extension Exercise {

    @objc(insertObject:inEquipmentAtIndex:)
    @NSManaged public func insertIntoEquipment(_ value: Equipment, at idx: Int)

    @objc(removeObjectFromEquipmentAtIndex:)
    @NSManaged public func removeFromEquipment(at idx: Int)

    @objc(insertEquipment:atIndexes:)
    @NSManaged public func insertIntoEquipment(_ values: [Equipment], at indexes: NSIndexSet)

    @objc(removeEquipmentAtIndexes:)
    @NSManaged public func removeFromEquipment(at indexes: NSIndexSet)

    @objc(replaceObjectInEquipmentAtIndex:withObject:)
    @NSManaged public func replaceEquipment(at idx: Int, with value: Equipment)

    @objc(replaceEquipmentAtIndexes:withEquipment:)
    @NSManaged public func replaceEquipment(at indexes: NSIndexSet, with values: [Equipment])

    @objc(addEquipmentObject:)
    @NSManaged public func addToEquipment(_ value: Equipment)

    @objc(removeEquipmentObject:)
    @NSManaged public func removeFromEquipment(_ value: Equipment)

    @objc(addEquipment:)
    @NSManaged public func addToEquipment(_ values: NSOrderedSet)

    @objc(removeEquipment:)
    @NSManaged public func removeFromEquipment(_ values: NSOrderedSet)

}

// MARK: Generated accessors for log
extension Exercise {

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

// MARK: Generated accessors for muscle
extension Exercise {

    @objc(insertObject:inMuscleAtIndex:)
    @NSManaged public func insertIntoMuscle(_ value: Muscle, at idx: Int)

    @objc(removeObjectFromMuscleAtIndex:)
    @NSManaged public func removeFromMuscle(at idx: Int)

    @objc(insertMuscle:atIndexes:)
    @NSManaged public func insertIntoMuscle(_ values: [Muscle], at indexes: NSIndexSet)

    @objc(removeMuscleAtIndexes:)
    @NSManaged public func removeFromMuscle(at indexes: NSIndexSet)

    @objc(replaceObjectInMuscleAtIndex:withObject:)
    @NSManaged public func replaceMuscle(at idx: Int, with value: Muscle)

    @objc(replaceMuscleAtIndexes:withMuscle:)
    @NSManaged public func replaceMuscle(at indexes: NSIndexSet, with values: [Muscle])

    @objc(addMuscleObject:)
    @NSManaged public func addToMuscle(_ value: Muscle)

    @objc(removeMuscleObject:)
    @NSManaged public func removeFromMuscle(_ value: Muscle)

    @objc(addMuscle:)
    @NSManaged public func addToMuscle(_ values: NSOrderedSet)

    @objc(removeMuscle:)
    @NSManaged public func removeFromMuscle(_ values: NSOrderedSet)

}

// MARK: Generated accessors for trainingEtemplate
extension Exercise {

    @objc(addTrainingEtemplateObject:)
    @NSManaged public func addToTrainingEtemplate(_ value: TrainingExerciseTemplate)

    @objc(removeTrainingEtemplateObject:)
    @NSManaged public func removeFromTrainingEtemplate(_ value: TrainingExerciseTemplate)

    @objc(addTrainingEtemplate:)
    @NSManaged public func addToTrainingEtemplate(_ values: NSSet)

    @objc(removeTrainingEtemplate:)
    @NSManaged public func removeFromTrainingEtemplate(_ values: NSSet)

}

// MARK: Generated accessors for trainings
extension Exercise {

    @objc(addTrainingsObject:)
    @NSManaged public func addToTrainings(_ value: Training)

    @objc(removeTrainingsObject:)
    @NSManaged public func removeFromTrainings(_ value: Training)

    @objc(addTrainings:)
    @NSManaged public func addToTrainings(_ values: NSSet)

    @objc(removeTrainings:)
    @NSManaged public func removeFromTrainings(_ values: NSSet)

}

extension Exercise : Identifiable {

}
