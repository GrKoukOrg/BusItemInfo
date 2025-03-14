//
//  SettingsView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 14/3/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var customAPIURL: String = AppSettings.apiURL
    
    var body: some View {
        Form {
            Section(header: Text("API Settings")) {
                TextField("API URL", text: $customAPIURL)
                    .textFieldStyle(.roundedBorder)
                
                Button("Save") {
                    AppSettings.apiURL = customAPIURL
                }
                
                Button("Reset to Default") {
                    AppSettings.resetAPIURL()
                    customAPIURL = AppSettings.apiURL
                }
            }
            
            Section {
                Text("Current API URL: \(AppSettings.apiURL)")
            }
        }
        .navigationTitle("Settings")
    }
}
