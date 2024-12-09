import Foundation
import Alamofire

class AddAccountViewModel: ObservableObject {
    @Published var rib: String = ""  // Account RIB
    @Published var nickname: String = ""  // Account Nickname
    @Published var otp: [String] = Array(repeating: "", count: 6)  // OTP (6 digits)
    @Published var currentStep: Int = 1
    @Published var accountExists: Bool = false  // Flag to check if the account exists in DB
    
    let totalSteps: Int = 3
    
    // Validate the form for each step
    func isStepValid() -> Bool {
        switch currentStep {
        case 1: // Step 1: RIB validation
            return !rib.isEmpty
        case 2: // Step 2: Nickname validation
            return !nickname.isEmpty
        case 3: // Step 3: OTP validation
            return otp.allSatisfy { !$0.isEmpty }
        default:
            return false
        }
    }
    
    // Move to the next step after successful validation
    func moveToNextStep() {
        if currentStep == 1 {
            // Step 1: Search Account by RIB
            checkIfAccountExists(rib: rib)
        } else if currentStep < totalSteps, isStepValid() {
            currentStep += 1
        }
    }

    // Check if the account exists in the database based on RIB
    private func checkIfAccountExists(rib: String) {
        // API call to check if the account exists
        AccountRepository.shared.checkAccountExistence(rib: rib) { result in
            switch result {
            case .success(let account):
                if account != nil {
                    self.accountExists = true
                    self.currentStep = 2  // Move to Step 2 (nickname)
                } else {
                    self.accountExists = false
                    print("Account with RIB \(rib) not found.")
                }
            case .failure(let error):
                print("Error checking account existence: \(error.localizedDescription)")
            }
        }
    }

    // Save account data after OTP validation
    func saveAccount() {
        guard isStepValid() else {
            print("Account not saved due to validation failure.")
            return
        }

        let accountData: [String: Any] = [
            "rib": rib,
            "nickname": nickname,
            "otp": otp.joined()
        ]

        AccountRepository.shared.updateAccount(accountData: accountData) { result in
            switch result {
            case .success:
                print("Account updated successfully!")
            case .failure(let error):
                print("Error updating account: \(error.localizedDescription)")
            }
        }
    }
}

