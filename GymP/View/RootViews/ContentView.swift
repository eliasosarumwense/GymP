//
//  ContentView.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var manager: DataManager = DataManager()
        @StateObject private var trainingState = TrainingState.shared
        @StateObject private var colorSettings = ColorSettings()
    init() {
        let customFont = UIFont(name: "Lexend-SemiBold", size: 11)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: customFont,
            ], for: .normal)
    }
        var body: some View {
            // Setup environment objects to be shared across views
                MainAppView()
                    .environmentObject(colorSettings)
                    .environmentObject(manager)
                    .environment(\.managedObjectContext, manager.container.viewContext)
                    .environmentObject(trainingState)
                    .onAppear() {
                        manager.preloadExercises()
                    }
            
        }
}


/*
let standardAppearance = UITabBarAppearance()
standardAppearance.shadowColor = UIColor(Color.black)

let itemAppearance = UITabBarItemAppearance()
itemAppearance.normal.iconColor = UIColor(Color.gray)
itemAppearance.selected.iconColor = UIColor(Color.orange)
itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.gray)]
itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.orange)]

let normalFontAttributes = [NSAttributedString.Key.font: UIFont(name: "Lexend-Regular", size: 9)!]
itemAppearance.normal.titleTextAttributes = normalFontAttributes

standardAppearance.inlineLayoutAppearance = itemAppearance
standardAppearance.stackedLayoutAppearance = itemAppearance
standardAppearance.compactInlineLayoutAppearance = itemAppearance

UITabBar.appearance().standardAppearance = standardAppearance
 */
