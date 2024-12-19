//
//  WalletCard.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI

struct WalletCard: View {
    let wallet: WalletSolana
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Wallet Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(wallet.currency)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text((wallet.publicKey?.prefix(15) ?? "") + "...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "creditcard.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Divider()
            
            // Balance
            VStack(alignment: .leading, spacing: 4) {
                Text("Balance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(String(format: "%.2f %@", wallet.balance, wallet.currency))
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            // Stats
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Transactions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(wallet.transactions?.count ?? 0)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
      
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .onTapGesture(perform: onTap)
    }
}

