//
//  HealthKitClass.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import Foundation
import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available on this device.")
            return
        }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if success {
                print("Authorization granted.")
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "No error")")
            }
        }
    }
}
