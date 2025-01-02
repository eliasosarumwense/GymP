//
//  CustomNavigationBar.swift
//  GymP
//
//  Created by Elias Osarumwense on 30.06.24.
//

import SwiftUI
import UIKit

func CustomNavBar() {
    // Create a UINavigationBarAppearance instance for standard appearance
    let standardAppearance = UINavigationBarAppearance()
    
    // Define attributes for standard title and large title
    let standardTitleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Lexend-Bold", size: 15)!
    ]
    
    // Set the standard appearance attributes
    standardAppearance.titleTextAttributes = standardTitleAttributes
    standardAppearance.largeTitleTextAttributes = standardTitleAttributes
    
    // Create a UINavigationBarAppearance instance for scroll edge appearance
    let scrollEdgeAppearance = UINavigationBarAppearance()
    
    // Define attributes for scroll edge title and large title
    let scrollEdgeTitleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Lexend-Bold", size: 29)!
    ]
    
    // Set the scroll edge appearance attributes
    scrollEdgeAppearance.titleTextAttributes = scrollEdgeTitleAttributes
    scrollEdgeAppearance.largeTitleTextAttributes = scrollEdgeTitleAttributes
    
    // Customize the global appearance of the UINavigationBar
    let navBar = UINavigationBar.appearance()
    navBar.prefersLargeTitles = false
    navBar.isTranslucent = true
    navBar.standardAppearance = standardAppearance
    navBar.compactAppearance = standardAppearance
    navBar.scrollEdgeAppearance = scrollEdgeAppearance
    navBar.compactScrollEdgeAppearance = standardAppearance
    
}

struct NavigationBarModifier: ViewModifier {
    
    init(backgroundColor: UIColor = .clear, foregroundColor: UIColor = .label, tintColor: UIColor? = nil, withSeparator: Bool = true) {
        
        // Standard title attributes
        let standardTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Lexend-Bold", size: 17)!,
            .foregroundColor: foregroundColor
        ]
        
        // Configure UINavigationBarAppearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = standardTitleAttributes
        navBarAppearance.largeTitleTextAttributes = standardTitleAttributes
        navBarAppearance.backgroundColor = backgroundColor
        
        // Remove separator if required
        if !withSeparator {
            navBarAppearance.shadowColor = .clear
        }
        
        // Apply appearance settings
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().isTranslucent = true
        // Apply tintColor if provided
        if let tintColor = tintColor {
            UINavigationBar.appearance().tintColor = tintColor
        }
    }
    
    func body(content: Content) -> some View {
        content
    }
}

// A preview to see your modifier is a way to apply it to the original struct.
#Preview {
    NavigationStack {
        Text("My Text Text")
         // To display our modifier in the preview or in your view is a way to see its effect.
        //.modifier(NavigationBarModifier(backgroundColor: .systemBackground, foregroundColor: .blue, tintColor: nil, withSeparator: false))
            .navigationTitle("Test title")
            .navigationBarModifier(backgroundColor: .systemBackground, foregroundColor: .systemBlue, tintColor: nil, withSeparator: true)
        
            
    }
}
extension View {
    func navigationBarModifier(backgroundColor: UIColor = .systemBackground, foregroundColor: UIColor = .label, tintColor: UIColor?, withSeparator: Bool) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, withSeparator: withSeparator))
    }
}

