//
//  ContentView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 10/3/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current API URL: \(AppSettings.apiURL)")
                NavigationLink("Edit Settings"){
                    SettingsView()
                }
                    
                Spacer()
                if let scannedBarcode = vm.scannedResult {
                    Text("Scanned Result: \(scannedBarcode)")
                        .padding()
                    
                    Button("Scan Again") {
                        vm.resetScanner()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                } else {
                    NavigationLink(destination: ScannerView()) {
                        Text("Go to Scanner")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
        
}
