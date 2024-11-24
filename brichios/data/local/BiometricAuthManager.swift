
import SwiftUI
import Foundation
import LocalAuthentication

struct BiometricError: Identifiable {
    let id = UUID()
    let message: String
}

class BiometricAuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var biometricError: String?
    @Published private var text = "LOCKED"
    private let context = LAContext()
    
    // Vérifie si la biométrie est disponible
    func canUseBiometrics() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    // Authentifie l'utilisateur avec la biométrie
    func authenticateUser(completion: @escaping (Bool) -> Void) {
     
        guard canUseBiometrics() else {
            biometricError = "Biometric is not enrolled"
            completion(false)
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                             localizedReason: "Please authenticate !") { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    completion(true)
                } else {
                    self.biometricError = error?.localizedDescription
                    completion(false)
                }
            }
        }
    }
}
