//
//  EmptyWalletsView.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI

struct EmptyWalletsView: View {
    @Binding var showCreateWalletSheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wallet.pass.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Wallets Yet")
                .font(.headline)
            
            Text("Create your first wallet to start managing your funds")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showCreateWalletSheet = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Wallet")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

