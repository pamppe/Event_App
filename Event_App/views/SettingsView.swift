/// SETTINGSVIEW


//
//  SettingsView.swift
//  Event_App
//
//  Created by iosdev on 15.11.2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var activeTab: Int = 0
    /// Sample toggle states
    @State private var toggles: [Bool] = Array(repeating: false, count: 10)
    /// Interface style
    @State private var toggleDarkMode: Bool = false
    @State private var activateDarkMode: Bool = false
    @State private var buttonRect: CGRect = .zero
    var body: some View {
        /// Sample view
        TabView(selection: $activeTab) {
            NavigationStack {
                List {
                    Section("Language") {
                        Toggle("English", isOn: $toggles[0])
                        Toggle("Finnish", isOn: $toggles[1])
                    }
                    Section {
                    } footer: {
                        Text("Sample footer")
                    }
                }
                .navigationTitle("Settings")
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                toggleDarkMode.toggle()
            }, label: {
            Image(systemName: toggleDarkMode ?  "sun.max.fill" : "moon.fill")
                .font(.title2)
                .foregroundStyle(Color.primary)
                
                .frame(width: 40, height: 40)
            })
                .padding(10)
                .background {
                    GeometryReader(content: { geometry in
                        
                    })
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
