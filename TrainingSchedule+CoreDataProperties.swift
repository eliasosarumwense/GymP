//
//  TrainingSchedule+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 07.02.25.
//
//

import Foundation
import CoreData


extension TrainingSchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingSchedule> {
        return NSFetchRequest<TrainingSchedule>(entityName: "TrainingSchedule")
    }

    @NSManaged public var weekDay: Int16
    @NSManaged public var weekofMonth: Int16
    @NSManaged public var recurringDay: Int16
    @NSManaged public var color: String?
    @NSManaged public var note: String?
    @NSManaged public var training: Training?

}

extension TrainingSchedule : Identifiable {

}
