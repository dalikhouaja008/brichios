import Foundation

class AddAccountViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var number: String = ""
    @Published var type: String = "Savings"
    
    @Published var currentStep: Int = 1
    let totalSteps: Int = 3

    private let accountTypes = ["Savings", "Checking"]

    func validateForm() {
        if name.isEmpty || number.isEmpty {
            print("Validation failed: Missing required fields")
            return
        }
    }

    func saveAccount() {
        print("Account added: \(name), \(number), \(type)")
    }

    func getAccountTypes() -> [String] {
        return accountTypes
    }
}
