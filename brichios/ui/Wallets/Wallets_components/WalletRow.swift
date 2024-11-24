//
//  WalletRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI
struct WalletRow: View {
    var wallet: Wallet
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(wallet.currency)
                .font(.headline)
                .foregroundColor(Color.blue) // Add a blue accent to wallet currency
            Text("\(wallet.symbol)\(String(format: "%.2f", wallet.balance))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
