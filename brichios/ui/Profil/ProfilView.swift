//
//  ProfilView.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var authViewModel = Auth.shared
    @State private var showLogoutConfirmation = false
    @State private var showResetPasswordSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Profile Header
                VStack(spacing: 15) {
                    // Profile Image
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue)
                        .shadow(color: .gray.opacity(0.3), radius: 10)
                    
                    // User Email
                    Text(authViewModel.getCredentials().email ?? "User")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding()
                
                // Action Buttons
                VStack(spacing: 20) {
                    // Logout Button
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "escape")
                            Text("Logout")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.red, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    // Reset Password Button
                    Button(action: {
                        showResetPasswordSheet = true
                    }) {
                        HStack {
                            Image(systemName: "lock.rotation")
                            Text("Reset Password")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            // Logout Confirmation Dialog
            .confirmationDialog("Are you sure you want to logout?", isPresented: $showLogoutConfirmation) {
                Button("Logout", role: .destructive) {
                    authViewModel.logout()
                }
            }
            
            // Reset Password Sheet (Placeholder)
            .sheet(isPresented: $showResetPasswordSheet) {
                ResetPasswordView()
            }
        }
    }
}

// Reset Password View
struct ResetPasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Password")
                        .font(.subheadline)
                    SecureField("Enter current password", text: $currentPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("New Password")
                        .font(.subheadline)
                    SecureField("Enter new password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Confirm New Password")
                        .font(.subheadline)
                    SecureField("Confirm new password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                Button(action: {
                    // TODO: Implement password reset logic
                    print("Reset Password Tapped")
                }) {
                    Text("Reset Password")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .navigationBarItems(trailing:
                Button("Cancel") {
                    // Dismiss sheet
                }
            )
        }
    }
}

#Preview {
    ProfileView()
}
