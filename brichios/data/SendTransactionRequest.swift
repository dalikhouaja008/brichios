//
//  SendTransactionRequest.swift
//  brichios
//
//  Created by Mac Mini 2 on 9/12/2024.
//

import Foundation
struct SendTransactionRequest: Codable {
    let fromWalletPublicKey: String
    let toWalletPublicKey: String
    let amount: Double
}
