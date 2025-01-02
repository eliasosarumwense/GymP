//
//  HapticFeedback.swift
//  GymP
//
//  Created by Elias Osarumwense on 17.08.24.
//

import Foundation
import UIKit

func triggerHapticFeedbackRigid() {
    let generator = UIImpactFeedbackGenerator(style: .rigid)
    generator.impactOccurred()
}

func triggerHapticFeedbackLight() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

func triggerHapticFeedbackSoft() {
    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()
}
