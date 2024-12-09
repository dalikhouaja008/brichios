//
//  CurrencyConversionRequest.swift
//  brichios
//
//  Created by Mac Mini 2 on 9/12/2024.
//

import Foundation
struct CurrencyConversionRequest: Codable {
    let amount: Double
    let fromCurrency: String
}
