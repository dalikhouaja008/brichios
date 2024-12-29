//
//  WalletViewModel.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation

enum SendTransactionState: Equatable {
    case idle
    case loading
    case success(signature: String?)
    case error(message: String)
}

enum CreateTNDWalletState: Equatable {
    case idle
    case loading
    case success(wallet: WalletSolana)
    case error(message: String)
    
    // Implémentation de Equatable
    static func == (lhs: CreateTNDWalletState, rhs: CreateTNDWalletState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success(let wallet1), .success(let wallet2)):
            return wallet1.id == wallet2.id
        case (.error(let message1), .error(let message2)):
            return message1 == message2
        default:
            return false
        }
    }
}

class WalletViewModel: ObservableObject {
    @Published var uiState = WalletUI()
    private let repository = WalletRepository()
    @Published var sendTransactionState: SendTransactionState = .idle
    @Published var createWalletState: CreateTNDWalletState = .idle
    
    func createTNDWallet(amount: Double) {
            createWalletState = .loading
            
            Task {
                do {
                    let wallet = try await repository.createTNDWallet(amount: amount)
                    await MainActor.run {
                        createWalletState = .success(wallet: wallet)
                        fetchWallets()  // Déplacé après le succès
                    }
                } catch {
                    await MainActor.run {
                        createWalletState = .error(message: error.localizedDescription)
                    }
                }
            }
        }
    
    
    
    
    
    func sendTransaction(
          fromWalletPublicKey: String,
          toWalletPublicKey: String,
          amount: Double
      ) {
          // Reset transaction state to loading
          sendTransactionState = .loading
          
          Task {
              do {
                  let signature = try await repository.sendTransaction(
                      fromWalletPublicKey: fromWalletPublicKey,
                      toWalletPublicKey: toWalletPublicKey,
                      amount: amount
                  )
                  
                  // Perform updates on the main thread
                  await MainActor.run {
                      // Update transaction state to success
                      sendTransactionState = .success(signature: signature)
                      
                      // Refresh wallets after successful transaction
                      fetchWallets()
                  }
              } catch {
                  // Perform error handling on the main thread
                  await MainActor.run {
                      sendTransactionState = .error(message: error.localizedDescription)
                  }
              }
          }
      }
    
    
    func fetchWallets() {
        uiState.isLoading = true
        Task {
            do {
                let allWallets = try await repository.getUserWallets()
                
                // Separate TND wallet from other wallets
                let tndWallet = allWallets.first { $0.currency == "TND" }
                let otherWallets = allWallets.filter { $0.currency != "TND" }
                
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.wallets = otherWallets
                    self.uiState.TNDWallet = tndWallet
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


