//
//  ItemDetailView.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 20/3/25.
//

import SwiftUI

struct ItemDetailView: View {
    @State private var viewModel: ItemDetailViewModel
    
    init(item: item) {
        _viewModel = State(initialValue: ItemDetailViewModel(item: item))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Item Details")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                
                Group {
                    Text("ID: \(viewModel.id)")
                    Text("Name: \(viewModel.name)")
                    Text("Code: \(viewModel.code)")
                    if let measureUnitName = viewModel.measureUnitName {
                        Text("Measure Unit: \(measureUnitName)")
                    }
                    if let categoryName = viewModel.categoryName {
                        Text("Category: \(categoryName)")
                    }
                    if let vatCategoryName = viewModel.vatCategoryName {
                        Text("VAT Category: \(vatCategoryName)")
                    }
                    if let barcodes = viewModel.barcodes {
                        Text("Barcodes: \(barcodes)")
                    }
                }
                
                Group {
                    if let apothema = viewModel.apothema {
                        Text("Stock: \(apothema)")
                    }
                    Text("Purchase Price: \(viewModel.timiAgorasFormatted)")
                    Text("Purchase Price (VAT): \(viewModel.timiAgorasFpaFormatted)")
                    Text("Retail Price: \(viewModel.timiPolisisLianFormatted)")
                    Text("Retail Price (VAT): \(viewModel.timiPolisisLianFpaFormatted)")
                }
                Group {
                    Text("Markup (Retail Price): \(viewModel.markupLian)")
                    Text("Markup (Retail Price + VAT): \(viewModel.markupLianFpa)")
                }
                Spacer()
            }
            .padding()
            .navigationTitle(viewModel.name)
        }
    }
}
