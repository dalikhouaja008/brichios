//
//  Account.swift
//  brichios
//
//  Created by Mac Mini 2 on 21/11/2024.
//

import Foundation

struct Account: Identifiable {
    let id = UUID()
    var name: String
    var number: String
    var type: String
    
}
