//
//  ForgetPasswordViewModel.swift
//  brichios
//
//  Created by Mac Mini 2 on 14/12/2024.
//

import Foundation

struct ForgetPasswordUI {
    var email: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var isSuccess: Bool = false
}

class ForgetPasswordViewModel: ObservableObject {
    @Published var uiState = ForgetPasswordUI()
    private let repository: UserRepository
    
    init(repository: UserRepository = UserRepository()) {
        self.repository = repository
    }
    
    func forgotPassword() {
        guard validateEmail() else { return }
        
        uiState.isLoading = true
        uiState.errorMessage = nil
        
        repository.forgotPassword(email: uiState.email) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.uiState.isLoading = false
                
                switch result {
                case .success:
                    self.uiState.isSuccess = true
                case .failure(let error):
                    self.uiState.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func validateEmail() -> Bool {
        if uiState.email.isEmpty {
            uiState.errorMessage = "Email field is empty"
            return false
        }
        
        if !isValidEmail(uiState.email) {
            uiState.errorMessage = "Please enter a valid email"
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
