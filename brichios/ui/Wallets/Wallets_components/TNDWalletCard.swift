//
//  TNDWalletCard.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI

struct TNDWalletCard: View {
    let wallet: WalletSolana
    @StateObject private var viewModel = WalletViewModel()
    @State private var showFundWalletSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Balance Display
            VStack(spacing: 8) {
                Text("TND Balance")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(String(format: "%.2f TND", wallet.originalAmount ?? 0.0))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            // Fund Wallet Button
            Button(action: {
                showFundWalletSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text("Fund Wallet")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        .padding(.horizontal)
        .sheet(isPresented: $showFundWalletSheet) {
            TNDWalletFund(viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
}


