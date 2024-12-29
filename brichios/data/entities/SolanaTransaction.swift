//
//  SolanaTransaction.swift
//  brichios
//
//  Created by Mac Mini 2 on 18/12/2024.
//

import Foundation

struct SolanaTransaction: Identifiable, Codable {
    let id: String
    let signature: String
    let walletPublicKey: String
    let blockTime: Int
    let amount: Double
    let type: String
    let status: String
    let fromAddress: String
    let toAddress: String
    let fee: Double
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" 
        case signature
        case walletPublicKey
        case blockTime
        case amount
        case type
        case status
        case fromAddress
        case toAddress
        case fee
        case timestamp
    }
}
