import SwiftUI

class ListAccountsViewModel: ObservableObject {
    @Published var accounts: [CustomAccount] = [
        CustomAccount(name: "Account 1", balance: 4500, isDefault: true),
        CustomAccount(name: "Account 2", balance: 3200, isDefault: false),
        CustomAccount(name: "Account 3", balance: 2750, isDefault: false),
        CustomAccount(name: "Account 4", balance: 8550, isDefault: false)
    ]
    
    @Published var selectedAccount: CustomAccount? {
        didSet {
            if let account = selectedAccount {
                name = account.name
                balance = account.balance
                isDefault = account.isDefault
            }
        }
    }
    
    @Published var name: String = ""
    @Published var balance: Double = 0.0
    @Published var isDefault: Bool = false
    @Published var type: String = "Savings"

    init() {
        selectedAccount = accounts.first
        if let account = selectedAccount {
            name = account.name
            balance = account.balance
            isDefault = account.isDefault
        }
    }

    func toggleDefault(for account: CustomAccount) {
        accounts.indices.forEach { index in
            accounts[index].isDefault = accounts[index].id == account.id
        }
    }

    func getAccountTypes() -> [String] {
        return ["Savings", "Checking", "Business"]
    }
}
