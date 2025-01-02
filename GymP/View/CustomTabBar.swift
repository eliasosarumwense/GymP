//
//  CustomTabBar.swift
//  GymP
//
//  Created by Elias Osarumwense on 19.06.24.
//

import SwiftUI
import UIKit

struct CustomTabbar: View {
    @EnvironmentObject var colorSettings: ColorSettings
    @Environment(\.colorScheme) var colorScheme
    @Binding var currentTab: Tab
    @Binding var previousTab: Tab

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    triggerHapticFeedbackSoft()
                    previousTab = currentTab
                    withAnimation {
                        currentTab = tab
                    }
                }
            label: {
                    VStack {
                        Image(systemName: getImage(rawValue: tab.rawValue))
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(currentTab == tab ? colorSettings.selectedColor : .gray)
                            .scaleEffect(currentTab == tab ? 1.15 : 1)
                    }
                    .offset(y: -10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            .offset(y: -5)
            }
        }
        .frame(height: 60)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                //.fill(.black.opacity(0.5)) // Semi-transparent black fill
                .fill(.ultraThinMaterial) // Apple's Material effect for translucency
                .clipShape(RoundedRectangle(cornerRadius: 15)) // Clip the material effect to the shape
                //.shadow(color: .black, radius: 10, x: 0, y: 5)
                //.shadow(color: colorScheme == .dark ? Color.black : Color.white, radius: 8, x: -0, y: -9)
                //.shadow(color: Color(red: 163/255, green: 177/255, blue: 198/255), radius: 8, x: 0, y: 9)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.thickMaterial, lineWidth: 1)
                )
        }
        .padding(.horizontal, 0)
        .padding(.bottom, -20)
    }

    func getImage(rawValue: String) -> String {
        switch rawValue {
        case "Exercises":
            return "figure.core.training"
        case "Logs":
            return "text.line.last.and.arrowtriangle.forward"
        case "Home":
            return "house.fill"
        case "Instances":
            return "note.text"
        case "Trainings":
            return "figure.strengthtraining.traditional"
        default:
            return ""
        }
    }
}

struct CustomTabbar_Previews: PreviewProvider {
    @State static var currentTab: Tab = .home
    @State static var previousTab: Tab = .exercises
    @StateObject static var colorSettings = ColorSettings()

    static var previews: some View {
        Group {
            CustomTabbar(currentTab: $currentTab, previousTab: $previousTab)
                .environmentObject(colorSettings)
                .environment(\.colorScheme, .light) // Light mode preview
            
            CustomTabbar(currentTab: $currentTab, previousTab: $previousTab)
                .environmentObject(colorSettings)
                .environment(\.colorScheme, .dark) // Dark mode preview
        }
    }
}

// Helper to create stateful previews
struct StatefulPreviewWrapper<Value: Hashable, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial)) // Adjust style as needed
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // Nothing to update
    }
}


