//
//  WalletRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//

import SwiftUI

struct WalletRow: View {
    var wallet: Wallet

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(wallet.currency)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(wallet.symbol) \(String(format: "%.2f", wallet.balance))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            Spacer()
            Image(systemName: "wallet.pass.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}
