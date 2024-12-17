import Foundation
import Combine

class AddAccountViewModel: ObservableObject {
    @Published var rib: String = ""
    @Published var nickname: String = ""
    @Published var otp: [String] = Array(repeating: "", count: 6)
    @Published var currentStep: Int = 1
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var showAlert: Bool = false
    
    let totalSteps: Int = 3
    private let api = AccountsAPI.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Get token from Auth.shared
    private var token: String? {
        Auth.shared.getAccessToken()
    }
    
    // Validate the form for each step
    func isStepValid() -> Bool {
        switch currentStep {
        case 1:
            return !rib.isEmpty && rib.count >= 5
        case 2:
            return !nickname.isEmpty && nickname.count >= 3
        case 3:
            return otp.allSatisfy { !$0.isEmpty }
        default:
            return false
        }
    }
    
    private func checkIfAccountExists() {
        guard let token = token else {
            error = "Session expirée. Veuillez vous reconnecter."
            showAlert = true
            return
        }
        
        guard !rib.isEmpty else { return }
        isLoading = true
        
        api.findByRIB(rib: rib, token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] account in
                self?.currentStep = 2
            }
            .store(in: &cancellables)
    }
    
    func moveToNextStep() {
        if currentStep == 1 {
            checkIfAccountExists()
        } else if currentStep < totalSteps, isStepValid() {
            currentStep += 1
        }
    }
    
    func saveAccount() {
        guard let token = token else {
            error = "Session expirée. Veuillez vous reconnecter."
            showAlert = true
            return
        }
        
        guard isStepValid() else {
            error = "Veuillez remplir tous les champs correctement."
            showAlert = true
            return
        }
        
        let otpString = otp.joined()
        guard otpString.count == 6 else {
            error = "Veuillez entrer un code OTP valide à 6 chiffres."
            showAlert = true
            return
        }
        
        isLoading = true
        
        api.updateNickname(rib: rib, nickname: nickname, token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error.localizedDescription
                    self?.showAlert = true
                case .finished:
                    NotificationCenter.default.post(
                        name: .accountAdded,
                        object: nil,
                        userInfo: ["rib": self?.rib ?? ""]
                    )
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func resetForm() {
        rib = ""
        nickname = ""
        otp = Array(repeating: "", count: 6)
        currentStep = 1
        error = nil
        showAlert = false
    }
}

extension Notification.Name {
    static let accountAdded = Notification.Name("accountAdded")
}
