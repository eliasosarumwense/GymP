//
//  GymPApp.swift
//  GymP
//
//  Created by Elias Osarumwense on 15.06.24.
//

import SwiftUI


@main
struct GymPApp: App {
    
    private let activeTrainingInstanceKey = "activeTrainingInstance"
    
    init() {
        //let manager = DataManager()
        //manager.preloadExercises()

        //UINavigationBar.appearance().barTintColor = .black
        //UINavigationBar.appearance().tintColor = .white
       // UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //UINavigationBar.appearance().prefersLargeTitles = true
        
        //UITabBar.appearance().barTintColor = .black
        //UITabBar.appearance().tintColor = .black
        //UINavigationBar.appearance().isTranslucent = false
        
        //CustomNavBar()
        //UserDefaults.standard.removeObject(forKey: activeTrainingInstanceKey)
    }
    var body: some Scene {
        WindowGroup {
                ContentView()
                .applyBackground(color: Color.cremeOrangeWhite)

                .modifier(NavigationBarModifier(tintColor: UIColor(red: 0.95, green: 0.47, blue: 0.25, alpha: 1.0), withSeparator: false))
                            
            }
        
   
    }

}
