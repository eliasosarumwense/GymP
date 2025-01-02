//
//  Muscle+CoreDataProperties.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//
//

import Foundation
import CoreData


extension Muscle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Muscle> {
        return NSFetchRequest<Muscle>(entityName: "Muscle")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var intensity: String?
    @NSManaged public var name: String?
    @NSManaged public var exercise: Exercise?

}

extension Muscle : Identifiable {

}
