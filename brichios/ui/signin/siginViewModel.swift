import Foundation
struct LoginUiState {
    var isLoading: Bool
    var isLoggedIn: Bool
    var token: String?
    var refreshToken: String?
    var user: User?
    var errorMessage: String?
    var hasNavigated: Bool
    
    init(
        isLoading: Bool = false,
        isLoggedIn: Bool = false,
        token: String? = nil,
        refreshToken: String? = nil,
        user: User? = nil,
        errorMessage: String? = nil,
        hasNavigated: Bool = false
    ) {
        self.isLoading = isLoading
        self.isLoggedIn = isLoggedIn
        self.token = token
        self.refreshToken = refreshToken
        self.user = user
        self.errorMessage = errorMessage
        self.hasNavigated = hasNavigated
    }
}

class SigninViewModel: ObservableObject {
    private let userRepository: UserRepository
    @Published private(set) var loginUiState = LoginUiState()
    @Published var passwordError: String = ""
    @Published var emailError: String = ""
    
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func loginUser(email: String, password: String, isRemembered: Bool) {
        loginUiState = LoginUiState(isLoading: true)
        let loginRequest = LoginRequest(email: email, password: password)
        print("Login Request:", loginRequest)
        userRepository.login(request: loginRequest) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let loginResponse):
                    print("Login successful - Token:", loginResponse.accessToken)
                    // Sauvegardez les tokens dasn defaultsvalues
                    Auth.shared.setCredentials(
                       accessToken: loginResponse.accessToken,
                       refreshToken: loginResponse.refreshToken,
                       email: loginResponse.user.email,
                       password: loginResponse.user.password,
                       isRemembered: isRemembered
                  )
                                       
                    self.loginUiState = LoginUiState(
                        isLoading: false,
                        isLoggedIn: true,
                        token: loginResponse.accessToken,
                        refreshToken: loginResponse.refreshToken,
                        user: loginResponse.user
                    )
                case .failure(let error):
                    print("Login failed:", error)
                    self.loginUiState = LoginUiState(
                        isLoading: false,
                        isLoggedIn: false,
                        errorMessage: "Échec de la connexion: \(error.localizedDescription)"
                    )
                }
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
                    user:loginResponse.user
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
    
   
     func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


