//
//  signupViewModel.swift
//  brichios
//
//  Created by Mac Mini 2 on 13/11/2024.
//

import Foundation

struct SignUpUiState {
    var isLoading: Bool
    var isSignedUp: Bool
    var user: User?
    var errorMessage: String?
    
    init(
        isLoading: Bool = false,
        isSignedUp : Bool = false,
        user: User? = nil,
        errorMessage: String? = nil
    ) {
        self.isLoading = isLoading
        self.isSignedUp = isSignedUp
        self.user = user
        self.errorMessage = errorMessage
    }
}
class SignupViewModel: ObservableObject {
    private let userRepository: UserRepository
    @Published private(set) var signUpUiState = SignUpUiState()
    @Published var passwordError: String = ""
    @Published var emailError: String = ""
    @Published var phoneError: String = ""
    @Published var usernameError: String = ""
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    
    func signup(newUser : User) {
           // Mettre à jour l'état de chargement
           signUpUiState = SignUpUiState(isLoading: true)
           // Appeler le repository
           userRepository.createUser(user: newUser) { [weak self] result in
               guard let self = self else { return }
               
               DispatchQueue.main.async {
                   switch result {
                   case .success(let createdUser):
                       // Mise à jour de l'état avec succès
                       self.signUpUiState = SignUpUiState(
                           isLoading: false,
                           isSignedUp: true,
                           user: createdUser
                       )
                       print("Signup successful - User:", createdUser)
                       
                   case .failure(let error):
                       // Mise à jour de l'état avec erreur
                       self.signUpUiState = SignUpUiState(
                           isLoading: false,
                           isSignedUp: false,
                           errorMessage: error.localizedDescription
                       )
                       print("Signup failed:", error)
                   }
               }
           }
       }
    func resetErrors() {
        emailError = ""
        passwordError = ""
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            emailError = "Email field is empty"
            return false
        }
        if !isValidEmail(email) {
            emailError = "Please enter a valid email"
            return false
        }
        emailError = ""
        return true
    }
    
    func validatePassword(_ password: String) -> Bool {
        if password.isEmpty {
            passwordError = "Password field is empty"
            return false
        }
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            return false
        }
        passwordError = ""
        return true
    }
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.isEmpty {
            phoneError = "Phone number field is empty"
            return false
        }
        // Vérifier que le numéro de téléphone contient exactement 8 chiffres
        let phoneRegex = "^[0-9]{8}$" // Regex pour 8 chiffres
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if !phonePredicate.evaluate(with: phoneNumber) {
            phoneError = "Phone number must be exactly 8 digits"
            return false
        }
        
        phoneError = ""
        return true
    }
    
    func validateUsername(_ username: String) -> Bool {
        if username.isEmpty {
            usernameError = "Username field is empty"
            return false
        }
        usernameError = ""
        return true
    }
    
     func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

