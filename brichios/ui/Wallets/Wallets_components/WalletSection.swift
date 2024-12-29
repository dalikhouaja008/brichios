//
//  WalletSection.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI

struct WalletsSection: View {
    @ObservedObject var viewModel: WalletViewModel
    @Binding var selectedWallet: WalletSolana?
    @Binding var showCreateWalletSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Header
            HStack {
                Text("My Wallets")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !viewModel.uiState.wallets.isEmpty {
                    Button(action: {
                        showCreateWalletSheet = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("New")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            
            // Content
            if viewModel.uiState.isLoading {
                LoadingWalletsView()
            } else if let errorMessage = viewModel.uiState.errorMessage {
                ErrorWalletsView(message: errorMessage)
            } else if viewModel.uiState.wallets.isEmpty {
                EmptyWalletsView(showCreateWalletSheet: $showCreateWalletSheet)
            } else {
                // Wallets Scroll View
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.uiState.wallets) { wallet in
                            WalletCard(
                                wallet: wallet,
                                isSelected: selectedWallet?.id == wallet.id,
                                onTap: {
                                    selectedWallet = (selectedWallet?.id == wallet.id) ? nil : wallet
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    if selectedWallet == nil && !viewModel.uiState.wallets.isEmpty {
                        selectedWallet = viewModel.uiState.wallets.first
                    }
                }
            }
        }
    }
}
