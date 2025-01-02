//
//  PlusVIew.swift
//  GymP
//
//  Created by Elias Osarumwense on 09.08.24.
//

import SwiftUI

struct PlusView: View {
    @State var show = false
    @State private var navigateToTraining = false
    
    var body: some View {
        NavigationView {
            TabBarCircle(show: $show)
                .overlay {
                    ZStack {
                        
                        if show {
                            VStack(alignment: .leading, spacing: 22.7) {
                                ButtonMenu(icon: "figure.core.training", title: "Exercise", action: {
                                    withAnimation {
                                        show.toggle()
                                    }
                                })
                                
                                ButtonMenu(icon: "location.circle.fill", title: "Muscles", action: {
                                    withAnimation {
                                        show.toggle()
                                    }
                                })
                                
                                ButtonMenu(icon: "text.line.last.and.arrowtriangle.forward", title: "Logs", action: {
                                    withAnimation {
                                        show.toggle()
                                    }
                                })
                                
                                ButtonMenu(icon: "point.3.connected.trianglepath.dotted", title: "Instances", action: {
                                    withAnimation {
                                        show.toggle()
                                    }
                                })
                                
                                ButtonMenu(icon: "figure.strengthtraining.traditional", title: "Training", action: {
                                    navigateToTraining = true // Set the navigation trigger
                                    withAnimation {
                                        show.toggle()
                                    }
                                })
                            }
                            .foregroundColor(show ? .white : .clear)
                        } else {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                                .padding(6)
                        }
                    }
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(30)
                }
                .background(
                    NavigationLink(destination: TrainingsView(), isActive: $navigateToTraining) {
                        EmptyView()
                    }
                )
        }
    }
}

struct ButtonMenu: View {
    var icon: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.footnote)
                    .frame(width: 30, height: 30)
                    .background(Color.gray, in: Circle())
                Text(title)
                    .foregroundColor(.white)
            }
        }
        .tint(.primary)
    }
}

#Preview {
    PlusView()
}
