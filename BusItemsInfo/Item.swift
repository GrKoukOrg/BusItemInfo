//
//  Item.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 13/3/25.
//

import Foundation
import SwiftData

@Model()
class item:  Identifiable {
    @Attribute(.unique) var id: Int
    var code: String
    var name: String
    var measureUnitId: Int?
    var measureUnitName: String?
    var categoryId: Int?
    var categoryName: String?
    var vatCategoryId: Int?
    var vatCategoryName: String?
    var barcodes:String?
    var apothema: Double?
    var timiAgoras: Decimal
    var timiAgorasFpa: Decimal
    var timiPolisisLian: Decimal
    var timiPolisisLianFpa: Decimal

    init(id: Int, code: String, name: String, measureUnitId: Int?, measureUnitName: String?, categoryId: Int?, categoryName: String?, vatCategoryId: Int?, vatCategoryName: String?, barcodes:String?, apothema: Double?, timiAgoras: Decimal, timiAgorasFpa: Decimal, timiPolisisLian: Decimal, timiPolisisLianFpa: Decimal) {
        self.id = id
        self.code = code
        self.name = name
        self.measureUnitId = measureUnitId
        self.measureUnitName = measureUnitName
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.vatCategoryId = vatCategoryId
        self.vatCategoryName = vatCategoryName
        self.barcodes = barcodes
        self.apothema = apothema
        self.timiAgoras = timiAgoras
        self.timiAgorasFpa = timiAgorasFpa
        self.timiPolisisLian = timiPolisisLian
        self.timiPolisisLianFpa = timiPolisisLianFpa
    }
    
}

@Model
class supplier: Identifiable {
    @Attribute(.unique) var id: Int
    var code: String
    var name: String
    var afm: String
    
    init(id: Int, code: String, name: String, afm: String) {
        self.id = id
        self.code = code
        self.name = name
        self.afm = afm
    }
}
