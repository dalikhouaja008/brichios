import SwiftUI

// OTP ViewModel
class OTPViewModel: ObservableObject {
    @Published var otp: [String] = ["", "", "", "", "", ""]
    @Published var isOTPValid: Bool = false
    @Published var isSubmitting: Bool = false
    
    // Validate if OTP is complete
    var isComplete: Bool {
        otp.allSatisfy { !$0.isEmpty }
    }
    
    // Submit OTP
    func submitOTP() {
        guard isComplete else { return }
        isSubmitting = true
        
        // Simulate an API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isSubmitting = false
            self.handleOTPSubmission()
        }
    }
    
    private func handleOTPSubmission() {
        // Here, validate the OTP or call an API.
        let otpString = otp.joined()
        print("OTP Submitted: \(otpString)")
        // Handle actual OTP validation logic here.
    }
    
    // Validate OTP
    func validateOTP() -> Bool {
        return otp.joined().count == otp.count // Validate OTP length
    }
}
