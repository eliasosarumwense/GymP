//
//  TestSlide.swift
//  GymP
//
//  Created by Elias Osarumwense on 25.08.24.
//

import SwiftUI

class TabControllerContext: ObservableObject {
    @Published var selected: panels = .one {
        didSet {
            if previous != selected {
                insertion = selected.makeMove(previous)
                removal = previous.makeMove(selected)
                
                withAnimation {
                    trigger = selected
                    previous = selected
                }
            }
        }
    }
    
    @Published var trigger: panels = .one
    @Published var previous: panels = .one
    
    var insertion: AnyTransition = .move(edge: .leading)
    var removal: AnyTransition = .move(edge: .trailing)
}

struct TabsWithTransitionsView: View {
    @EnvironmentObject var context: TabControllerContext
    
    var body: some View {
        VStack {
            Picker("Select Panel", selection: $context.selected) {
                ForEach(panels.allCases) { panel in
                    Text(panel.labelText).tag(panel)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ZStack {
                if context.trigger == .one {
                    SettingssView()
                        //.background(panels.one.color)
                        .transition(.asymmetric(insertion: context.insertion, removal: context.removal))
                } else if context.trigger == .two {
                    HomeeView()
                        //.background(panels.two.color)
                        .transition(.asymmetric(insertion: context.insertion, removal: context.removal))
                }
            }
            .animation(.easeInOut, value: context.trigger) // Ensure the view transition is animated
        }
    }
}

enum panels: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    
    var id: Int { self.rawValue }
    
    var labelText: String {
        switch self {
        case .one: return "Settings"
        case .two: return "Home"
        }
    }
    
    var color: Color {
        switch self {
        case .one: return Color.red.opacity(0.5)
        case .two: return Color.green.opacity(0.5)
        }
    }
    
    func makeMove(_ otherPanel: panels) -> AnyTransition {
        return otherPanel.rawValue < self.rawValue ? .move(edge: .trailing) : .move(edge: .leading)
    }
}

struct TabsWithTransitionsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsWithTransitionsView().environmentObject(TabControllerContext())
    }
}

struct SettingssView: View {
    var body: some View {
        Text("Settings View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeeView: View {
    var body: some View {
        Text("Home View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
