import SwiftUI

// Sign In View

struct Login: View {
    @State private var mail = ""
    @State private var pass = ""
    @State private var isLoading = false
    @State private var isRemembered = false
    @State private var loginSuccess = false
    @State private var showPassword = false
    @ObservedObject var viewModel: SigninViewModel
    @State private var navigateToHome = false
    
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope")
                            .foregroundColor(.black)
                        TextField("Enter Email Address", text: self.$mail)
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.emailError.isEmpty ? Color.gray.opacity(0.3) : Color.red, lineWidth: 1)
                    )
                    
                    if !viewModel.emailError.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                            Text(viewModel.emailError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.leading, 4)
                        .transition(.opacity)
                    }
                }
                .padding(.bottom, 16)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 15) {
                        Image(systemName: "lock")
                            .resizable()
                            .frame(width: 15, height: 18)
                            .foregroundColor(.black)
                        
                        if showPassword {
                            TextField("Enter Password", text: $pass)
                        } else {
                            SecureField("Enter Password", text: $pass)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.passwordError.isEmpty ? Color.gray.opacity(0.3) : Color.red, lineWidth: 1)
                    )
                    
                    if !viewModel.passwordError.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                            Text(viewModel.passwordError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding(.leading, 4)
                        .transition(.opacity)
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding(.top, 25)
            .padding(.horizontal)
            Toggle(isOn: $isRemembered) {
                Text("Se souvenir de moi")
                    .font(.subheadline)
            }
            .padding(.horizontal)

            Button(action: {
                validateAndLogin()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 100, height: 50)
                } else {
                    Text("LOGIN")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 100)
                        .background(Color.red)
                        .cornerRadius(8)
                        .offset(y: -40)
                        .padding(.bottom, -40)
                        .shadow(radius: 15)
                }
            }
            
        }.fullScreenCover(isPresented: $navigateToHome) {
            SignUp(viewModel:SignupViewModel(userRepository: UserRepository())) // Navigation vers Home()
        }
    }
    private func validateAndLogin() {
        // Réinitialiser les erreurs
        viewModel.resetErrors()
        // Valider l'email et le mot de passe
        let isEmailValid = viewModel.validateEmail(mail)
        let isPasswordValid = viewModel.validatePassword(pass)
        
        // Si les deux sont valides, procéder à la connexion
        if isEmailValid && isPasswordValid {
            isLoading = true
            viewModel.loginUser(email: mail, password: pass, isRemembered: isRemembered)
            // Observer le changement d'état de connexion
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
                if viewModel.loginUiState.isLoggedIn {
                    self.loginSuccess = true
                    self.navigateToHome = true
                }
            }
        }
    }
    
}




