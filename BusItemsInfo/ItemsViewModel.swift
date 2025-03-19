//
//  ItemsViewModel.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 19/3/25.
//

import SwiftUI
import Combine
import SwiftData

@Observable
class ItemsViewModel {
    var items: [item] = []
    var isLoading = false
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    func fetchItems()
    {
        guard let url = URL(string: "\(AppSettings.apiURL)/api/erpapi/getitems") else {
            print("Invalid URL")
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { DispatchQueue.main.async { self.isLoading = false } }
            
            if let data = data {
                do {
                    let decodedItems = try JSONDecoder().decode([item].self, from: data)
                    DispatchQueue.main.async {
                        self.items = decodedItems
                        self.saveItemsToSwiftData(decodedItems)
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            } else if let error = error {
                print("Failed to fetch data: \(error)")
            }
        }.resume()
    }
    private func saveItemsToSwiftData(_ items: [item]) {
        for itemData in items {
           
            let fetchDescriptor = FetchDescriptor<item>(predicate: #Predicate { $0.id == itemData.id })
            do {
                let existingItems = try modelContext.fetch(fetchDescriptor)
                
                if let existingItem = existingItems.first {
                    // Update existing item
                    existingItem.code = itemData.code
                    existingItem.name = itemData.name
                    existingItem.measureUnitId = itemData.measureUnitId
                    existingItem.measureUnitName = itemData.measureUnitName
                    existingItem.categoryId = itemData.categoryId
                    existingItem.categoryName = itemData.categoryName
                    existingItem.vatCategoryId = itemData.vatCategoryId
                    existingItem.vatCategoryName = itemData.vatCategoryName
                    existingItem.barcodes = itemData.barcodes
                    existingItem.apothema = itemData.apothema
                    existingItem.timiAgoras = itemData.timiAgoras
                    existingItem.timiAgorasFpa = itemData.timiAgorasFpa
                    existingItem.timiPolisisLian = itemData.timiPolisisLian
                    existingItem.timiPolisisLianFpa = itemData.timiPolisisLianFpa
                } else {
                    // Insert new item
                    let newItem = item(
                        id: itemData.id,
                        code: itemData.code,
                        name: itemData.name,
                        measureUnitId: itemData.measureUnitId,
                        measureUnitName: itemData.measureUnitName,
                        categoryId: itemData.categoryId,
                        categoryName: itemData.categoryName,
                        vatCategoryId: itemData.vatCategoryId,
                        vatCategoryName: itemData.vatCategoryName,
                        barcodes: itemData.barcodes,
                        apothema: itemData.apothema,
                        timiAgoras: itemData.timiAgoras,
                        timiAgorasFpa: itemData.timiAgorasFpa,
                        timiPolisisLian: itemData.timiPolisisLian,
                        timiPolisisLianFpa: itemData.timiPolisisLianFpa
                    )
                    modelContext.insert(newItem)
                }
                
                try modelContext.save()
                 printDatabasePath() // Print database path after saving
            } catch {
                print("Failed to save or update items in SwiftData: \(error)")
            }
        }
    }
}
private func printDatabasePath() {
    do {
        let appSupport = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let databasePath = appSupport.appendingPathComponent("BusItemsInfo.sqlite") // Adjust the filename if needed
        print("Database Path: \(databasePath.path)")
    } catch {
        print("Failed to get database path: \(error)")
    }
}
