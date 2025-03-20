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
    
    // Improved filtering logic
    var filteredItems: [item] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedSearchText.isEmpty {
            return items // Show all items when no search is active
        } else {
            return items.filter { item in
                item.name.localizedStandardContains(trimmedSearchText) ||
                item.code.localizedStandardContains(trimmedSearchText) ||
                (item.barcodes?.localizedStandardContains(trimmedSearchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search items", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Display List Based on Search Results
                if filteredItems.isEmpty {
                    Text("No items found for '\(searchText)'")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(filteredItems) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
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
                        .listStyle(PlainListStyle()) // Improved appearance
                    }
                }
                Spacer()
                // Buttons Section
                HStack {
                    NavigationLink(destination: SettingsView()) {
                        Text("Edit Settings")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: SyncView()) {
                        Text("Sync Items")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: ScannerView()) {
                        Text("Scan Code")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                //.padding(.top)
            }
            .navigationTitle("Home")
        }
        .onChange(of: vm.scannedResult) { oldValue, newValue in
            if let scannedBarcode = newValue {
                searchText = scannedBarcode // Set searchText to scanned barcode
                vm.scannedResult = nil      // Reset scanned result
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
