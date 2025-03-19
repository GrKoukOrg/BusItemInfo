//
//  SyncView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 19/3/25.
//

import SwiftUI

struct SyncView: View {
    @Environment(\.modelContext) private var modelContext // Access ModelContext from the environment
        @Bindable private var viewModel: SyncViewModel
   
    init() {
            self.viewModel = SyncViewModel(modelContext: PersistenceController.shared.container.mainContext)
        }
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Processing items...", value: Double(viewModel.processedItems), total: Double(viewModel.totalItems))
                    .progressViewStyle(LinearProgressViewStyle())
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        if !viewModel.updateMessages.isEmpty {
                            Text("Item Updates:")
                                .font(.headline)
                                .padding(.top)
                            ForEach(viewModel.updateMessages, id: \.self) { message in
                                Text(message)
                                    .font(.body)
                                    .padding(.leading)
                            }
                        }
                        if let summary = viewModel.summary {
                            Text(summary)
                                .font(.headline)
                                .padding(.top)
                        }
                    }
                }
            }

            Button("Fetch Items") {
                viewModel.fetchItems()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle("Items")
    }
}

#Preview {
    SyncView()
}
