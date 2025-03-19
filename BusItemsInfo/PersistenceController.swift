//
//  PersistenceController.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 19/3/25.
//


import SwiftData

@MainActor
struct PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init(inMemory: Bool = false) {
        let schema = Schema([item.self]) // Replace with your model(s)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        do {
            container = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
}
