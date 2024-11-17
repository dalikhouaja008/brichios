//
//  forgetPasswordView.swift
//  brichios
//
//  Created by Mac Mini 2 on 13/11/2024.
//

import SwiftUI
struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Enter your email address to reset your password.")
                .font(.subheadline)
                .padding()

            TextField("Email Address", text: .constant(""))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Reset password action
            }) {
                Text("Submit")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
            }
            .background(Color.white)
            .clipShape(Capsule())
            .padding(.top, 20)

            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}
