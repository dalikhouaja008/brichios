//
//  WalletDetailView.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI
struct WalletDetailView: View {
    var wallet: Wallet
    
    var body: some View {
        VStack {
            Text(wallet.currency)
                .font(.title)
                .foregroundColor(Color.blue) // Color the title
                .padding()
            Text("Balance: \(wallet.symbol)\(String(format: "%.2f", wallet.balance))")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            // Add more detailed wallet information here
        }
        .navigationTitle(wallet.currency)
        .navigationBarTitleDisplayMode(.inline)
    }
}
