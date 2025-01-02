//
//  TrainingInstance+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//
//

import Foundation
import CoreData


extension TrainingInstance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingInstance> {
        return NSFetchRequest<TrainingInstance>(entityName: "TrainingInstance")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var trainingend: Date?
    @NSManaged public var trainingstart: Date?
    @NSManaged public var log: NSSet?
    @NSManaged public var training: Training?

}

// MARK: Generated accessors for log
extension TrainingInstance {

    @objc(addLogObject:)
    @NSManaged public func addToLog(_ value: Log)

    @objc(removeLogObject:)
    @NSManaged public func removeFromLog(_ value: Log)

    @objc(addLog:)
    @NSManaged public func addToLog(_ values: NSSet)

    @objc(removeLog:)
    @NSManaged public func removeFromLog(_ values: NSSet)

}

extension TrainingInstance : Identifiable {

}
