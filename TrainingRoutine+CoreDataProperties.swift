//
//  TrainingRoutine+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//
//

import Foundation
import CoreData


extension TrainingRoutine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingRoutine> {
        return NSFetchRequest<TrainingRoutine>(entityName: "TrainingRoutine")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var training: NSSet?

}

// MARK: Generated accessors for training
extension TrainingRoutine {

    @objc(addTrainingObject:)
    @NSManaged public func addToTraining(_ value: Training)

    @objc(removeTrainingObject:)
    @NSManaged public func removeFromTraining(_ value: Training)

    @objc(addTraining:)
    @NSManaged public func addToTraining(_ values: NSSet)

    @objc(removeTraining:)
    @NSManaged public func removeFromTraining(_ values: NSSet)

}

extension TrainingRoutine : Identifiable {

}
