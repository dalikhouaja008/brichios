import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var emailError: String?
    @State private var isLoading = false
    @State private var showOTPView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter your email to reset your password")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: email) { _ in validateEmail() }
                    
                    if let error = emailError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding()
                
                Button(action: resetPassword) {
                    HStack {
                        if isLoading {
                            ProgressView()
                        }
                        Text("Reset Password")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValidEmail ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(!isValidEmail || isLoading)
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }
            .padding()
            .navigationDestination(isPresented: $showOTPView) {
                OTPView()
            }
        }
    }
    
    private var isValidEmail: Bool {
        return email.range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil
    }
    
    private func validateEmail() {
        emailError = isValidEmail ? nil : "Invalid email format"
    }
    
    private func resetPassword() {
        guard isValidEmail else { return }
        
        isLoading = true
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            showOTPView = true
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForgotPasswordView()
            .preferredColorScheme(.light)
    }
}
