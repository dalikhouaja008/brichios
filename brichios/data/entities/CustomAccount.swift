//
//  CustomAccount.swift
//  brichios
//
//  Created by Mac Mini 2 on 21/11/2024.
//

import Foundation

struct CustomAccount: Identifiable {
    let id = UUID()
    var name: String
    var balance: Double
    var isDefault: Bool
}
