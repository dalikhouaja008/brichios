//
//  forgetPasswordView.swift
//  brichios
//
//  Created by Mac Mini 2 on 13/11/2024.
//
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var emailIsValid = true
    @State private var showError = false
    @State private var navigateToOTP = false // State to trigger navigation

    var body: some View {
        NavigationStack {
            VStack {
                // Title and Subtitle
                Text("Reset Password")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 100)
                
                Text("Enter your email address to reset your password.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                    .multilineTextAlignment(.center)

                // Email TextField
                TextField("Email Address", text: $email)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(RoundedRectangle(cornerRadius: 10).fill(emailIsValid ? Color.white : Color.red.opacity(0.2))) // Non-transparent background
                    .cornerRadius(10) // Ensure the corners are rounded
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: email) { _ in
                        validateEmail()
                    }
                    .padding(.top, 150)

                // Error Message
                if !emailIsValid {
                    Text("Please enter a valid email address.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }

                // Submit Button
                NavigationLink(
                    destination: OTPView(), // Navigate to OTPView
                    isActive: $navigateToOTP
                ) {
                    Button(action: {
                        if emailIsValid {
                            resetPassword()
                            navigateToOTP = true // Trigger navigation
                        } else {
                            showError = true
                        }
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                    }
                    .background(
                        emailIsValid ?
                        LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom) :
                        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    )
                    .clipShape(Capsule())
                    .disabled(!emailIsValid)
                    .padding(.top, 270)
                    .shadow(radius: 5)
                }

                // Cancel Button
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(.top, 5)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding([.leading, .trailing], 20) // Horizontal padding for spacing
            .background(LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)
        }
    }

    // Email validation function
    private func validateEmail() {
        // Basic email validation pattern
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let regex = try! NSRegularExpression(pattern: emailPattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        emailIsValid = regex.firstMatch(in: email, options: [], range: range) != nil
    }

    // Reset password action
    private func resetPassword() {
        // Simulate password reset and navigate
        print("Password reset request for: \(email)")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
/*import SwiftUI
struct ForgotPasswordBottomSheet: View {
        @Environment(\.dismiss) var dismiss
        @State private var email: String = ""

        var body: some View {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Enter your email address below, and we will send you instructions to reset your password.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)

                Button(action: {
                    // Reset password logic
                    print("Password reset email sent to \(email)")
                    dismiss() // Dismiss bottom sheet
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    dismiss() // Dismiss bottom sheet
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
    }*/
