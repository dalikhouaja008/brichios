import Foundation
struct LoginUiState {
    var isLoading: Bool
    var isLoggedIn: Bool
    var token: String?
    var refreshToken: String?
    var userId: String?
    var errorMessage: String?
    var hasNavigated: Bool
    
    init(
        isLoading: Bool = false,
        isLoggedIn: Bool = false,
        token: String? = nil,
        refreshToken: String? = nil,
        userId: String? = nil,
        errorMessage: String? = nil,
        hasNavigated: Bool = false
    ) {
        self.isLoading = isLoading
        self.isLoggedIn = isLoggedIn
        self.token = token
        self.refreshToken = refreshToken
        self.userId = userId
        self.errorMessage = errorMessage
        self.hasNavigated = hasNavigated
    }
}

//

class SigninViewModel: ObservableObject {
    private let userRepository: UserRepository
    
    @Published private(set) var loginUiState = LoginUiState()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func loginUser(email: String, password: String) {
        loginUiState = LoginUiState(isLoading: true)
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        userRepository.login(request: loginRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let loginResponse):
                self.loginUiState = LoginUiState(
                    isLoading: false,
                    isLoggedIn: true,
                    token: loginResponse.accessToken,
                    refreshToken: loginResponse.refreshToken,
                    userId: loginResponse.userId
                )
            case .failure(let error):
                self.loginUiState = LoginUiState(
                    isLoading: false,
                    isLoggedIn: false,
                    errorMessage: error.localizedDescription
                )
            }
        }
    }
    
    func loginUserWithBiometricAuth(email: String, password: String) {
        loginUiState = LoginUiState(isLoading: true)
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        userRepository.loginWithBiometric(request: loginRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let loginResponse):
                self.loginUiState = LoginUiState(
                    isLoading: false,
                    isLoggedIn: true,
                    token: loginResponse.accessToken,
                    refreshToken: loginResponse.refreshToken,
                    userId: loginResponse.userId
                )
            case .failure(let error):
                self.loginUiState = LoginUiState(
                    isLoading: false,
                    isLoggedIn: false,
                    errorMessage: error.localizedDescription
                )
            }
        }
    }
    
    // Reste des méthodes de validation inchangées
    
    func validateEmail(_ email: String, setError: (String) -> Void) -> Bool {
        if email.isEmpty {
            setError("Email must not be empty")
            return false
        } else if !isValidEmail(email) {
            setError("Please enter a valid email")
            return false
        } else {
            return true
        }
    }
    
    func validatePassword(_ password: String, setError: (String) -> Void) -> Bool {
        if password.isEmpty {
            setError("Password must not be empty")
            return false
        } else if password.count < 6 {
            setError("Password must be at least 6 characters")
            return false
        } else {
            return true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
