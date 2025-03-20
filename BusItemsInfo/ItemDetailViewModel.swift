//
//  ItemDetailViewModel.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 20/3/25.
//

import SwiftUI

@Observable
class ItemDetailViewModel {
    var item: item
    private let currencyFormatter: NumberFormatter
    
    init(item: item) {
        self.item = item
        self.currencyFormatter = NumberFormatter()
        self.currencyFormatter.numberStyle = .currency
        self.currencyFormatter.locale = Locale.current
    }
    
    var id: Int { item.id }
    var code: String { item.code }
    var name: String { item.name }
    var measureUnitName: String? { item.measureUnitName }
    var categoryName: String? { item.categoryName }
    var vatCategoryName: String? { item.vatCategoryName }
    var barcodes: String? { item.barcodes }
    var apothema: Double? { item.apothema }
    
    // Computed properties to format prices as currency
    var timiAgorasFormatted: String { formatCurrency(item.timiAgoras) }
    var timiAgorasFpaFormatted: String { formatCurrency(item.timiAgorasFpa) }
    var timiPolisisLianFormatted: String { formatCurrency(item.timiPolisisLian) }
    var timiPolisisLianFpaFormatted: String { formatCurrency(item.timiPolisisLianFpa) }
    
    private func formatCurrency(_ value: Decimal) -> String {
        return currencyFormatter.string(from: value as NSDecimalNumber) ?? "\(value)"
    }
}
