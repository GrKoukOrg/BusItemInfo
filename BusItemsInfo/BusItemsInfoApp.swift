//
//  BusItemsInfoApp.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 10/3/25.
//

import SwiftUI

@main
struct BusItemsInfoApp: App {
    @StateObject private var vm=AppViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .modelContainer(PersistenceController.shared.container)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
