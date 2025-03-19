//
//  SyncViewModel.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 19/3/25.
//

import SwiftUI
import Combine
import SwiftData

@Observable
class SyncViewModel {
    var items: [item] = []
    var updateMessages: [String] = []
    var isLoading = false
    var summary: String? = nil //
    var totalItems: Int = 0    // Total number of items to process
    var processedItems: Int = 0 // Number of items processed so far
    let modelContext: ModelContext
    
    private var addedCount = 0
    private var updatedCount = 0
    private let batchSize = 10
    
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
        addedCount = 0
        updatedCount = 0
        updateMessages = []
        summary = nil
        totalItems = 0
        processedItems = 0
        URLSession.shared.dataTask(with: url) { data, response, error in
            //defer { DispatchQueue.main.async { self.isLoading = false } }
            
            if let data = data {
                do {
                    let decodedItems = try JSONDecoder().decode([item].self, from: data)
                    DispatchQueue.main.async {
                        //self.items = decodedItems
                        self.totalItems = decodedItems.count
                        Task {
                            await self.saveItemsToSwiftData(decodedItems)
                            self.isLoading = false
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } else if let error = error {
                print("Failed to fetch data: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
   
    @MainActor
    private func saveItemsToSwiftData(_ items: [item]) async {
        totalItems = items.count
        processedItems = 0
        addedCount = 0
        updatedCount = 0
        let totalBatches = (items.count + batchSize - 1) / batchSize // Calculate number of batches
        for batchIndex in 0..<totalBatches {
            let startIndex = batchIndex * batchSize
            let endIndex = min(startIndex + batchSize, items.count)
            let batch = Array(items[startIndex..<endIndex])
            
            // Process each item in the batch
            for itemData in batch {
                await processItem(itemData)
            }
            
            // Update progress after each batch
            processedItems += batch.count
            await updateProgress()
        }
        
        // Display summary when done
        summary = "Processed \(totalItems) items: \(addedCount) added, \(updatedCount) updated"
        updateMessages.append(summary!)
        print(summary!)
        printDatabasePath()
    }
    
    @MainActor
    private func processItem(_ itemData: item) async {
        let predicate = Predicate<item> { item in
            PredicateExpressions.Equal(
                lhs: PredicateExpressions.KeyPath(root: item, keyPath: \.id),
                rhs: PredicateExpressions.Value(itemData.id)
            )
        }
        let fetchDescriptor = FetchDescriptor<item>(predicate: predicate)
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
                updatedCount += 1
                let message = "Updated item: \(itemData.name) (ID: \(itemData.id))"
                updateMessages.append(message)
                print(message)
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
                addedCount += 1
                let message = "Added item: \(itemData.name) (ID: \(itemData.id))"
                updateMessages.append(message)
                print(message)
            }
            try modelContext.save()
        } catch {
            let errorMessage = "Failed to save or update item \(itemData.name) (ID: \(itemData.id)): \(error)"
            updateMessages.append(errorMessage)
            print(errorMessage)
        }
    }
    
//    private func saveItemsToSwiftData(_ items: [item]) {
//        for (index, itemData) in items.enumerated() {
//            let predicate = Predicate<item> { item in
//                PredicateExpressions.Equal(
//                    lhs: PredicateExpressions.KeyPath(root: item, keyPath: \.id),
//                    rhs: PredicateExpressions.Value(itemData.id)
//                )
//            }
//            let fetchDescriptor = FetchDescriptor<item>(predicate: predicate)
//            do {
//                let existingItems = try modelContext.fetch(fetchDescriptor)
//                
//                if let existingItem = existingItems.first {
//                    // Update existing item
//                    existingItem.code = itemData.code
//                    existingItem.name = itemData.name
//                    existingItem.measureUnitId = itemData.measureUnitId
//                    existingItem.measureUnitName = itemData.measureUnitName
//                    existingItem.categoryId = itemData.categoryId
//                    existingItem.categoryName = itemData.categoryName
//                    existingItem.vatCategoryId = itemData.vatCategoryId
//                    existingItem.vatCategoryName = itemData.vatCategoryName
//                    existingItem.barcodes = itemData.barcodes
//                    existingItem.apothema = itemData.apothema
//                    existingItem.timiAgoras = itemData.timiAgoras
//                    existingItem.timiAgorasFpa = itemData.timiAgorasFpa
//                    existingItem.timiPolisisLian = itemData.timiPolisisLian
//                    existingItem.timiPolisisLianFpa = itemData.timiPolisisLianFpa
//                    updatedCount += 1
//                    let message = "Updated item: \(itemData.name) (ID: \(itemData.id))"
//                    //updateMessages.append(message)
//                    print(message)
//                } else {
//                    // Insert new item
//                    let newItem = item(
//                        id: itemData.id,
//                        code: itemData.code,
//                        name: itemData.name,
//                        measureUnitId: itemData.measureUnitId,
//                        measureUnitName: itemData.measureUnitName,
//                        categoryId: itemData.categoryId,
//                        categoryName: itemData.categoryName,
//                        vatCategoryId: itemData.vatCategoryId,
//                        vatCategoryName: itemData.vatCategoryName,
//                        barcodes: itemData.barcodes,
//                        apothema: itemData.apothema,
//                        timiAgoras: itemData.timiAgoras,
//                        timiAgorasFpa: itemData.timiAgorasFpa,
//                        timiPolisisLian: itemData.timiPolisisLian,
//                        timiPolisisLianFpa: itemData.timiPolisisLianFpa
//                    )
//                    modelContext.insert(newItem)
//                    addedCount += 1
//                    let message = "Added item: \(itemData.name) (ID: \(itemData.id))"
//                   // updateMessages.append(message)
//                    print(message)
//                }
//                
//                try modelContext.save()
//                if (index + 1) % self.batchSize == 0 || (index + 1) == items.count {
//                    DispatchQueue.main.async {
//                        self.items = items // Update items array for any potential future use
//                        self.updateMessages.append("Processed \(index + 1) items so far...")
//                        print("Processed \(index + 1) items so far...")
//                    }
//                }
//                
//                // If this is the last item, show the summary
//                if index + 1 == items.count {
//                    DispatchQueue.main.async {
//                        self.summary = "Processed \(items.count) items: \(self.addedCount) added, \(self.updatedCount) updated"
//                        self.updateMessages.append(self.summary!)
//                        print(self.summary!)
//                    }
//                }
//                
//            } catch {
//                let errorMessage = "Failed to save or update item \(itemData.name) (ID: \(itemData.id)): \(error)"
//                updateMessages.append(errorMessage)
//                print(errorMessage)
//            }
//        }
//        printDatabasePath() // Print database path after saving
//    }
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
@MainActor
private func updateProgress() async {
    // Optional: Add custom UI update logic here
    await Task.yield()
}
