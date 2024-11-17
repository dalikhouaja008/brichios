import SwiftUI

struct SignUp : View {
    @State var username = ""
    @State var mail = ""
    @State var phone = ""
    @State var pass = ""
    @State var repass = ""
    @State var passwordError = ""
    @State var usernameError = ""
    @State var mailerror = ""
    @State private var showPassword: Bool = false
    @State private var showRePassword: Bool = false
    @State private var isLoading = false
    @ObservedObject var viewModel: SignupViewModel
    
    var body: some View {
            VStack {
                VStack(spacing: 0) {
                    // Nom d'utilisateur
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.black)
                            TextField("Enter your name", text: self.$username)
                        }
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.usernameError.isEmpty ? Color.gray.opacity(0.3) : Color.red, lineWidth: 1)
                        )
                        
                        if !viewModel.usernameError.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                Text(viewModel.usernameError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.leading, 4)
                            .transition(.opacity)
                        }
                    }
                    .padding(.bottom, 16)

                    // Email
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

                    // Numéro de téléphone
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 15) {
                            Image(systemName: "phone")
                                .foregroundColor(.black)
                            TextField("Enter your phone number", text: self.$phone)
                                .keyboardType(.numberPad) // Pour un numéro de téléphone
                        }
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.phoneError.isEmpty ? Color.gray.opacity(0.3) : Color.red, lineWidth: 1)
                        )
                        
                        if !viewModel.phoneError.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                                Text(viewModel.phoneError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.leading, 4)
                            .transition(.opacity)
                        }
                    }
                    .padding(.bottom, 16)

                    // Mot de passe
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

                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(Color.gray)
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
                    }.padding(.bottom, 16)

                    // Confirmation du mot de passe
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 15) {
                            Image(systemName:"lock")
                                .resizable()
                                .frame(width: 15, height: 18)
                                .foregroundColor(.black)

                            if showRePassword {
                                TextField("Confirm Password", text: $repass)
                            } else {
                                SecureField("Confirm Password", text: $repass)
                            }

                            Button(action:{ showRePassword.toggle() }) {
                                Image(systemName: showRePassword ? "eye" : "eye.slash")
                                    .foregroundColor(Color.gray)
                            }
                            .padding(.trailing, 16)

                        }.padding(.vertical, 12).background(
                           RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth:1))

                    }

                }
                // Styles et marges
                .padding()
                .background(Color.white.cornerRadius(10))
                // Bouton d'inscription
                Button(action:{
                   validateAndSignUp() // Méthode pour valider et inscrire l'utilisateur
                }) {
                   Text("SIGN UP")
                       .foregroundColor(.white).fontWeight(.bold).padding()
                       // Style du bouton
                       //.frame(width:UIApplication.shared.windows.first?.bounds.width ?? UIScreen.main.bounds.width -100 )
                       //.background(Color.red).cornerRadius(8).shadow(radius :10 )
                }.background(Color.red).cornerRadius(8).shadow(radius :10 )
            }
            // Navigation vers la page d'accueil après l'inscription réussie
            //.fullScreenCover(isPresented:$navigateToHome){
            //   HomeView()
            //}
        }


    // Validation function for the sign-up form
    private func validateAndSignUp() {
        // Réinitialiser les erreurs
        viewModel.resetErrors()
        // Valider l'email et le mot de passe
        let isEmailValid = viewModel.validateEmail(mail)
        let isPasswordValid = viewModel.validatePassword(pass)
        let isPhoneValid = viewModel.validatePhoneNumber(phone)
        let isUsernameValid = viewModel.validateUsername(username)
        
        // Si les deux sont valides, procéder à la connexion
        if isEmailValid && isPasswordValid && isPhoneValid && isUsernameValid {
            isLoading = true
            var newUser = User(name: username, email: mail, numTel: phone, password: pass)
            viewModel.signup(newUser: newUser)
            
            // Observer le changement d'état de connexion
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
                if viewModel.signUpUiState.isSignedUp {
                    //self.navigateToHome = true
                    print("success")
                }
            }
        }
    }
}
