//
//  ItemDetailView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 19/3/25.
//

import SwiftUI

struct ItemsView: View {
    @Bindable private var viewModel = ItemsViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                List(viewModel.items) { item in
                    Text(item.name)
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
    ItemsView()
}
