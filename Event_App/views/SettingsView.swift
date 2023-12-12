//
//  SettingsView.swift
//  Event_App
//
//  Created by iosdev on 15.11.2023.
//

import SwiftUI

struct SettingsView: View {
  
    var body: some View {
            NavigationStack {
                List {
                    Section(NSLocalizedString("language", comment: "Language section title")) {
                        Text(NSLocalizedString("changeLanguage", comment: "Change language"))
                    }
                    Section {
                    } footer: {
                        Text(NSLocalizedString("sampleFooter", comment: "Sample footer text"))
                            .foregroundColor(.black)
                    }
                }
                .navigationTitle(NSLocalizedString("settingsTitle", comment: "Settings page title"))
            }
        }
    }

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
