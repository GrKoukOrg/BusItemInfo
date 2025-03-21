//
//  AboutView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 21/3/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("About This App")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            Text("App Name: \(Bundle.main.appName)")
                .font(.title2)
            
            Text("Version: \(Bundle.main.appVersion)")
                .font(.title2)
            
            Text("This app provides information about Not Only Tobacco inventory items, including their names, codes, barcodes and prices. You can search, sync, and scan items using this app.")
                .font(.body)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}


extension Bundle {
    var appName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Unknown"
    }
    
    var appVersion: String {
        let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let build = object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        return "\(version) (\(build))"
    }
}

#Preview {
    AboutView()
}
