//
//  transaction.swift
//  brichios
//
//  Created by Mac Mini 1 on 20/11/2024.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id: Int
    var status: String
    var description: String
    var amount: Double
    var date: Date
}
