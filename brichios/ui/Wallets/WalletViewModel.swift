//
//  WalletViewModel.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation

class WalletViewModel : ObservableObject{
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
     
    
}
