//
//  Equipment+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 07.02.25.
//
//

import Foundation
import CoreData


extension Equipment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Equipment> {
        return NSFetchRequest<Equipment>(entityName: "Equipment")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var exercise: Exercise?

}

extension Equipment : Identifiable {

}
