//
//  AppColorSetting.swift
//  GymP
//
//  Created by Elias Osarumwense on 11.08.24.
//

import Foundation
import SwiftUI

extension Color {
    static func from(data: Data) -> Color? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data).map(Color.init)
    }
    
    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false)
    }
}

// Step 2: Define a class to manage the selected color
class ColorSettings: ObservableObject {
    @Published var selectedColor: Color {
        didSet {
            if let data = selectedColor.encode() {
                UserDefaults.standard.set(data, forKey: "selectedColor")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "selectedColor"),
           let color = Color.from(data: data) {
            self.selectedColor = color
        } else {
            self.selectedColor = .accentColor
        }
    }
}
