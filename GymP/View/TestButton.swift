//
//  TestButton.swift
//  GymP
//
//  Created by Elias Osarumwense on 30.08.24.
//

import SwiftUI


struct NavBarButton: View {
    
    @EnvironmentObject var colorSettings: ColorSettings
    var buttonText: String
    var action: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Button(action: action) {
                Text(buttonText)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .customFont(.semiBold, 11)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .shadow(color: colorScheme == .dark ? Color.black : Color.white, radius: 8, x: -9, y: -9)
                    .shadow(color: Color(red: 163/255, green: 177/255, blue: 198/255), radius: 8, x: 9, y: 9)
                    .background(colorScheme == .dark ? Color.darkGray : Color(red: 224/255, green: 229/255, blue: 236/255))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: colorScheme == .dark ? Color.darkGray.opacity(0.1) : Color.gray.opacity(0.1), radius: 3, x: 0, y: 2)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
