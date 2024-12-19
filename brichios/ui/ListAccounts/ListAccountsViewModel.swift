// ListAccountsViewModel.swift
import SwiftUI
import Combine

class ListAccountsViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var selectedAccount: Account? {
        didSet {
            if let account = selectedAccount {
                nickname = account.nickname ?? ""
            }
        }
    }
    
    @Published var nickname: String = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var showError = false
    
    init() { }
    
    func addAccount(_ account: Account) {
        DispatchQueue.main.async {
            self.accounts.append(account)
            if self.accounts.count == 1 {
                self.selectedAccount = account
            }
        }
    }
    
    func updateNickname(for account: Account, newNickname: String) {
        guard let index = accounts.firstIndex(where: { $0.rib == account.rib }) else { return }
        if var updatedAccount = accounts[index] as? Account {
            accounts[index] = updatedAccount
            if selectedAccount?.rib == account.rib {
                selectedAccount = updatedAccount
            }
        }
    }
    
    func refreshAccounts() {
        objectWillChange.send()
    }
}

// Extension for UI compatibility
extension Account {
    var name: String {
        nickname ?? "Account"
    }
}
