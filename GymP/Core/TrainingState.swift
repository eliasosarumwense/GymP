//
//  TrainingState.swift
//  GymP
//
//  Created by Elias Osarumwense on 21.07.24.
//

import SwiftUI
import Combine
import CoreData

class TrainingState: ObservableObject {
    
    static let shared = TrainingState()
    
    @Published var isTrainingActive: Bool = false {
        didSet {
            saveState()
        }
    }
    
    @Published var activeTrainingID: UUID? = nil {
        didSet {
            saveState()
        }
    }
    
    @Published var activeInstanceID: UUID? = nil {
        didSet {
            saveState()
        }
    }
    
    @Published var activeTrainingName: String? = nil {
        didSet {
            saveState()
        }
    }
    
    private init() {
        loadState()
    }
    
    private let isTrainingActiveKey = "isTrainingActive"
    private let activeTrainingIDKey = "activeTrainingID"
    private let activeTrainingInstanceKey = "activeTrainingInstance"
    private let activeTrainingNameKey = "activeTrainingName"
    
    private func saveState() {
        UserDefaults.standard.set(isTrainingActive, forKey: isTrainingActiveKey)
        
        if let activeTrainingID = activeTrainingID {
            UserDefaults.standard.set(activeTrainingID.uuidString, forKey: activeTrainingIDKey)
        }
        
        if let activeInstanceID = activeInstanceID {
            UserDefaults.standard.set(activeInstanceID.uuidString, forKey: activeTrainingInstanceKey)
        }
        
        if let activeTrainingName = activeTrainingName {
            UserDefaults.standard.set(activeTrainingName, forKey: activeTrainingNameKey)
        }
    }
    
    func loadState() {
        isTrainingActive = UserDefaults.standard.bool(forKey: isTrainingActiveKey)
        
        if let activeTrainingIDString = UserDefaults.standard.string(forKey: activeTrainingIDKey),
           let activeTrainingID = UUID(uuidString: activeTrainingIDString) {
            self.activeTrainingID = activeTrainingID
        }
        
        if let activeInstanceIDString = UserDefaults.standard.string(forKey: activeTrainingInstanceKey),
           let activeInstanceID = UUID(uuidString: activeInstanceIDString) {
            self.activeInstanceID = activeInstanceID
        }
        
        if let activeTrainingName = UserDefaults.standard.string(forKey: activeTrainingNameKey) {
            self.activeTrainingName = activeTrainingName
        }
    }
    
    func deleteState() {
        UserDefaults.standard.removeObject(forKey: isTrainingActiveKey)
        UserDefaults.standard.removeObject(forKey: activeTrainingIDKey)
        UserDefaults.standard.removeObject(forKey: activeTrainingInstanceKey)
        UserDefaults.standard.removeObject(forKey: activeTrainingNameKey)
        
        // Reset the in-memory state as well
        isTrainingActive = false
        activeTrainingID = nil
        activeInstanceID = nil
        activeTrainingName = nil
    }
}
