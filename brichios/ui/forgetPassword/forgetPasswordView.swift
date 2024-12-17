import SwiftUI

struct ForgetPasswordView: View {
    @StateObject private var viewModel = ForgetPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isEmailFocused: Bool
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: viewModel.uiState.isLoading)
            
            VStack(spacing: 25) {
                // Custom navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Logo with shadow and animation
                        Image("logo")
                            .resizable()
                            .frame(width: 150, height: 135)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .scaleEffect(viewModel.uiState.isLoading ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                                     value: viewModel.uiState.isLoading)
                        
                        // Title with gradient text
                        Text("Forgot Password?")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        // Subtitle
                        Text("Don't worry! It happens. Please enter the email address associated with your account.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        // Email input field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email Address")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.callout)
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: 20)
                                
                                TextField("", text: $viewModel.uiState.email)
                                    .placeholder(when: viewModel.uiState.email.isEmpty) {
                                        Text("Enter your email").foregroundColor(.white.opacity(0.5))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .focused($isEmailFocused)
                                    .foregroundColor(.white)
                                
                                if !viewModel.uiState.email.isEmpty {
                                    Button(action: { viewModel.uiState.email = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .offset(x: shakeOffset)
                        }
                        .padding(.horizontal)
                        
                        // Submit button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
                                if !viewModel.validateEmail() {
                                    shakeAnimation()
                                } else {
                                    viewModel.forgotPassword()
                                }
                            }
                        }) {
                            HStack {
                                Text("Reset Password")
                                    .fontWeight(.semibold)
                                
                                if !viewModel.uiState.isLoading {
                                    Image(systemName: "arrow.right")
                                        .font(.body.bold())
                                }
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(colors: [.white, .white.opacity(0.9)],
                                             startPoint: .leading,
                                             endPoint: .trailing)
                            )
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        .disabled(viewModel.uiState.isLoading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    .padding(.top, 20)
                }
            }
            
            // Loading overlay
            if viewModel.uiState.isLoading {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            Text("Sending Instructions...")
                                .foregroundColor(.white)
                                .font(.callout)
                        }
                    )
                    .transition(.opacity)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.uiState.errorMessage != nil)) {
            Button("Try Again", role: .cancel) {
                viewModel.uiState.errorMessage = nil
            }
        } message: {
            if let error = viewModel.uiState.errorMessage {
                Text(error)
            }
        }
        .alert("Success", isPresented: $viewModel.uiState.isSuccess) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Password reset instructions have been sent to your email.")
        }
        .onTapGesture {
            isEmailFocused = false
        }
    }
    
    private func shakeAnimation() {
        let numberOfShakes = 6
        let duration = 0.4
        let animation = Animation.interactiveSpring(response: 0.1, dampingFraction: 0.3, blendDuration: 0.3)
        withAnimation(animation) {
            shakeOffset = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration / Double(numberOfShakes)) {
            withAnimation(animation) {
                shakeOffset = -10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 * duration / Double(numberOfShakes)) {
            withAnimation(animation) {
                shakeOffset = 0
            }
        }
    }
}

// Helper extension for placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    ForgetPasswordView()
}
