//
//  ContentView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 10/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var items: [item]
    @State private var searchText = ""
    
    var filteredItems: [item] {
        if searchText.isEmpty {
            return []
        } else {
            let filtered = items.filter { item in
                item.name.localizedStandardContains(searchText) ||
                item.code.localizedStandardContains(searchText) ||
                (item.barcodes?.localizedStandardContains(searchText) ?? false)
            }
            print("Search Text: '\(searchText)', Filtered Items Count: \(filtered.count)")
            return filtered
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            NavigationLink(destination: SettingsView()) {
                                Text("Edit Settings")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            NavigationLink(destination: SyncView()) {
                                Text("Sync Items")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                        }
                        
                        Text("Current API URL: \(AppSettings.apiURL)")
                            .padding(.top)
                        
                        TextField("Search items", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onChange(of: searchText) {
                                print("Items in database: \(items.count)")
                            }
                        
                        NavigationLink(destination: ScannerView()) {
                            Text("Scan Code")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        // Fixed conditional logic for displaying filtered items
                        if !searchText.isEmpty {
                            if filteredItems.isEmpty {
                                Text("No items found for '\(searchText)'")
                                    .foregroundColor(.gray)
                            } else {
                                List(filteredItems) { item in
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text("Code: \(item.code)")
                                            .font(.subheadline)
                                        if let barcodes = item.barcodes {
                                            Text("Barcodes: \(barcodes)")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                .frame(maxHeight: 300)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 100) // Adjusted for bottom buttons
                }
                
               
            }
            .navigationTitle("Home")
        }
        .onChange(of: vm.scannedResult) {
            if let scanned = vm.scannedResult {
                searchText = scanned
                vm.scannedResult = nil
            }
        }
        .onAppear {
            print("ContentView appeared. Total items: \(items.count)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PersistenceController(inMemory: true).container)
        .environmentObject(AppViewModel())
}
