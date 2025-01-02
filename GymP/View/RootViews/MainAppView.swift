//
//  MainAppView.swift
//  GymP
//
//  Created by Elias Osarumwense on 16.08.24.
//

import SwiftUI

struct MainAppView: View {
    @State private var currentTab: Tab = .trainings
    @State private var previousTab: Tab = .trainings
    //@StateObject private var manager: DataManager = DataManager()
    
    var training: Training? = nil

    var body: some View {
        NavigationStack {
            
            /*ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 40)
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()*/
            ZStack(alignment: .bottom) {
                Group {
                    if currentTab == .exercises {
                        ExercisesView(training: training ?? Training())
                            .applyBG()
                            .opacity(currentTab == .exercises ? 1 : 0)
                            .animation(.easeInOut, value: currentTab)
                         
                    } else if currentTab == .logs {
                        LogView()
                            .applyBG()
                            .opacity(currentTab == .logs ? 1 : 0)
                            .animation(.easeInOut, value: currentTab)
                    } else if currentTab == .home {
                        HomeView()
                            .applyBG()
                            .opacity(currentTab == .home ? 1 : 0)
                            .animation(.easeInOut, value: currentTab)
                    } else if currentTab == .instances {
                        InstanceView()
                            .applyBG()
                            .opacity(currentTab == .instances ? 1 : 0)
                            .animation(.easeInOut, value: currentTab)
                    } else if currentTab == .trainings {
                        TrainingsView()
                            .applyBG()
                            .opacity(currentTab == .trainings ? 1 : 0)
                            .animation(.easeInOut, value: currentTab)
                         
                    }
                }

                if currentTab == .trainings || currentTab == .exercises || currentTab == .logs || currentTab == .home || currentTab == .instances {
                    CustomTabbar(currentTab: $currentTab, previousTab: $previousTab)
                        .background(Color.clear)
                        .offset(y: 20)
                }
            }
            .onAppear {
                //manager.resetPersistentStore()
            }
            .onChange(of: currentTab) { newValue in
                previousTab = currentTab
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
}

struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var isTabBarVisible: Bool {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}
