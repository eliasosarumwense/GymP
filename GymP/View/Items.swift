//
//  Items.swift
//  GymP
//
//  Created by Elias Osarumwense on 08.08.24.
//

import SwiftUI

extension View{
    func applyBG() -> some View{
        self
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .ignoresSafeArea()
    }
}

enum Tab: String,CaseIterable{
    case exercises = "Exercises"
    case logs = "Logs"
    case home = "Home"
    case instances = "Instances"
    case trainings = "Trainings"
}
