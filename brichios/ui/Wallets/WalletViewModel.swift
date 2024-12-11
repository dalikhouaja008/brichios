//
//  WalletViewModel.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation

class WalletViewModel: ObservableObject {
    @Published var uiState = WalletUI()
    private let repository = WalletRepository()
    
    func fetchWallets() {
        uiState.isLoading = true
        Task {
            do {
                print("test")
                let wallets = try await repository.getUserWallets()
                print(wallets)
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.wallets = wallets
                }
            } catch {
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func convertCurrency(amount: Double, fromCurrency: String) {
        // Reset previous conversion state
        uiState.isLoading = true
        uiState.conversionError = nil
        uiState.convertedWallet = nil
        
        Task {
            do {
                print("converting wallet")
                let convertedWallet = try await repository.convertCurrency(amount: amount, fromCurrency: fromCurrency)
                print("converting wallet end")
                // Perform the conversion on the main thread
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.convertedWallet = convertedWallet
                    
                    // Optionally refresh wallets after conversion
                    self.fetchWallets()
                }
            } catch {
                // Handle conversion error on the main thread
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.conversionError = error.localizedDescription
                }
            }
        }
    }
}


