//
//  TransactionStatsHeader.swift
//  brichios
//
//  Created by Mac Mini 2 on 18/12/2024.
//

import Foundation
import SwiftUI
struct TransactionStatsHeader: View {
    let transactions: [SolanaTransaction]
    
    private var totalValue: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    private var totalSent: Double {
        transactions.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
    }
    
    private var totalReceived: Double {
        transactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        HStack {
            StatBox(title: "Total", value: totalValue, valueColor: .primary)
            StatBox(title: "Sent", value: totalSent, valueColor: .red)
            StatBox(title: "Received", value: totalReceived, valueColor: .green)
        }
    }
}
