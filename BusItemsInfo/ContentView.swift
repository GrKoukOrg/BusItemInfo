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
    @Environment(\.modelContext) private var modelContext // Access the ModelContext
    @Query var items: [item] // Fetches all items from SwiftData
    @State private var searchText = "" // State for search input
    // Computed property to filter items based on search text
    var filteredItems: [item] {
        if searchText.isEmpty {
            return [] // Hide list when search text is empty
        } else {
            let filtered = items.filter { item in
                item.name.localizedStandardContains(searchText) ||
                item.code.localizedStandardContains(searchText) ||
                (item.barcodes?.localizedStandardContains(searchText) ?? false)
            }
            print("Search Text: '\(searchText)', Filtered Items Count: \(filtered.count)") // Debugging
            return filtered
        }
    }
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main content with scrolling capability
                ScrollView {
                    VStack(spacing: 16) {
                        // Current API URL
                        Text("Current API URL: \(AppSettings.apiURL)")
                            .padding(.top)
                        
                        // Search box
                        TextField("Search items", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onChange(of: searchText) {
                                print("Items in database: \(items.count)") // Debugging total items
                            }
                        
                        // Scanner button
                        NavigationLink(destination: ScannerView()) {
                            Text("Scan Code")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        // Filtered items list (shown only when search text exists)
                        VStack {
                            if !searchText.isEmpty {
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
                            } else if !searchText.isEmpty {
                                Text("No items found for '\(searchText)'")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 10) // Extra space to avoid overlap with bottom buttons
                }
                
                // Bottom buttons (always visible)
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
                .padding()
            }
            .navigationTitle("Home")
        }
        // Update search text when a barcode is scanned
        .onChange(of: vm.scannedResult) {
            if let scanned = vm.scannedResult {
                searchText = scanned
                vm.scannedResult = nil
            }
        }
        .onAppear {
            // Debug initial state
            print("ContentView appeared. Total items: \(items.count)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PersistenceController(inMemory: true).container)
        .environmentObject(AppViewModel())
        
}
