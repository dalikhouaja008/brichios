//
//  wallet.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//

import Foundation

struct Wallet: Identifiable {
    let id = UUID()
    let currency: String
    let balance: Double
    let symbol: String
}
