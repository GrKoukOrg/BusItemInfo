//
//  Item.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 13/3/25.
//

import Foundation
import SwiftData

@Model()
class item:  Identifiable, Decodable {
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
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            code = try container.decode(String.self, forKey: .code)
            name = try container.decode(String.self, forKey: .name)
            measureUnitId = try container.decodeIfPresent(Int.self, forKey: .measureUnitId)
            measureUnitName = try container.decodeIfPresent(String.self, forKey: .measureUnitName)
            categoryId = try container.decodeIfPresent(Int.self, forKey: .categoryId)
            categoryName = try container.decodeIfPresent(String.self, forKey: .categoryName)
            vatCategoryId = try container.decodeIfPresent(Int.self, forKey: .vatCategoryId)
            vatCategoryName = try container.decodeIfPresent(String.self, forKey: .vatCategoryName)
            barcodes = try container.decodeIfPresent(String.self, forKey: .barcodes)
            apothema = try container.decodeIfPresent(Double.self, forKey: .apothema)
            timiAgoras = try container.decode(Decimal.self, forKey: .timiAgoras)
            timiAgorasFpa = try container.decode(Decimal.self, forKey: .timiAgorasFpa)
            timiPolisisLian = try container.decode(Decimal.self, forKey: .timiPolisisLian)
            timiPolisisLianFpa = try container.decode(Decimal.self, forKey: .timiPolisisLianFpa)
        }

        private enum CodingKeys: String, CodingKey {
            case id
            case code
            case name
            case measureUnitId
            case measureUnitName
            case categoryId
            case categoryName
            case vatCategoryId
            case vatCategoryName
            case barcodes
            case apothema
            case timiAgoras
            case timiAgorasFpa
            case timiPolisisLian
            case timiPolisisLianFpa
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
