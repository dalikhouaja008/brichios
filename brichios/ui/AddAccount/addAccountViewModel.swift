import Combine
import SwiftUI

class AddAccountViewModel: ObservableObject {
    @Published var rib: String = ""
    @Published var nickname: String = ""
    @Published var currentStep: Int = 1
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    @Published var showAlert: Bool = false
    @Published var isAccountAdded: Bool = false
    
    let totalSteps: Int = 2
    var onAccountAdded: ((Account) -> Void)?
    
    func isStepValid() -> Bool {
        switch currentStep {
        case 1:
            // Check if RIB is not empty and has the correct format
            return !rib.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2:
            // Check if nickname is not empty
            return !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        default:
            return false
        }
    }
    
    func moveToNextStep() {
        if currentStep < totalSteps {
            currentStep += 1
        }
    }
    
    func saveAccount() -> Bool {
        isLoading = true
        
        // Create account data as JSON
        let accountData: [String: Any] = [
            "id": UUID().uuidString,
            "rib": rib.trimmingCharacters(in: .whitespacesAndNewlines),
            "nickname": nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: accountData)
            let decoder = JSONDecoder()
            let newAccount = try decoder.decode(Account.self, from: jsonData)
            
            isLoading = false
            isAccountAdded = true
            onAccountAdded?(newAccount)
            return true
        } catch {
            isLoading = false
            self.error = error.localizedDescription
            showAlert = true
            return false
        }
    }
}
