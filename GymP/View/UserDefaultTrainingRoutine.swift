//
//  UserDefaultTrainingRoutine.swift
//  GymP
//
//  Created by Elias Osarumwense on 31.08.24.
//

import Foundation
import CoreData

func saveSelectedRoutineID(_ routineID: UUID?) {
    if let routineID = routineID {
        print("Saving selected routine ID: \(routineID.uuidString)")
        UserDefaults.standard.set(routineID.uuidString, forKey: "selectedTrainingRoutineID")
    } else {
        print("Saving nil for selected routine ID")
        UserDefaults.standard.removeObject(forKey: "selectedTrainingRoutineID")
    }
}

func loadSelectedRoutineID() -> UUID? {
    if let routineIDString = UserDefaults.standard.string(forKey: "selectedTrainingRoutineID") {
        print("Loaded routine ID string from UserDefaults: \(routineIDString)")
        if let routineID = UUID(uuidString: routineIDString) {
            print("Converted string to UUID: \(routineID)")
            return routineID
        } else {
            print("Failed to convert string to UUID")
        }
    } else {
        print("No routine ID found in UserDefaults")
    }
    return nil
}

func fetchRoutine(by id: UUID?, context: NSManagedObjectContext) -> TrainingRoutine? {
    guard let id = id else {
        print("fetchRoutine called with nil ID")
        return nil
    }
    
    print("Fetching routine with ID: \(id)")
    
    let fetchRequest: NSFetchRequest<TrainingRoutine> = TrainingRoutine.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    fetchRequest.fetchLimit = 1
    
    do {
        let fetchedRoutines = try context.fetch(fetchRequest)
        if let routine = fetchedRoutines.first {
            print("Successfully fetched routine: \(routine.name ?? "Unnamed Routine")")
            return routine
        } else {
            print("No routine found with ID: \(id)")
        }
    } catch {
        print("Failed to fetch routine by ID: \(error.localizedDescription)")
    }
    return nil
}
