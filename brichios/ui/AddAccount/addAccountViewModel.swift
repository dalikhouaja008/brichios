
import Foundation
class AddAccountViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var number: String = ""
    @Published var otp: [String] = Array(repeating: "", count: 6) // 6-digit OTP
    @Published var currentStep: Int = 1
    
    let totalSteps: Int = 3
    
    func validateForm() -> Bool {
        switch currentStep {
        case 1:
            if name.isEmpty {
                print("Validation failed: Name is required.")
                return false
            }
        case 2:
            if number.isEmpty {
                print("Validation failed: Account number is required.")
                return false
            }
        case 3:
            if otp.contains(where: { $0.isEmpty }) {
                print("Validation failed: OTP is incomplete.")
                return false
            }
        default:
            return false
        }
        print("Validation succeeded for step \(currentStep).")
        return true
    }
    func isStepValid() -> Bool {
           switch currentStep {
           case 1:
               return !name.isEmpty
           case 2:
               return !number.isEmpty
           case 3:
               return otp.allSatisfy { !$0.isEmpty }
           default:
               return false
           }
       }
    func saveAccount() {
        guard validateForm() else {
            print("Account not saved due to validation failure.")
            return
        }
        print("Account successfully saved:")
        print("Name: \(name), Number: \(number), OTP: \(otp.joined())")
    }
    
    func moveToNextStep() {
        if currentStep < totalSteps, validateForm() {
            currentStep += 1
        }
    }
}
