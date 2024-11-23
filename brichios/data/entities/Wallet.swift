//
//  Wallet.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
struct Wallet: Identifiable, Codable {
    var id = UUID()
    var currency: String
    var balance: Double
    var symbol: String
    var transactions: [Transaction]
    var cardImage: String?
}
