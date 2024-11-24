//
//  ViewController.swift
//  brichios
//
//  Created by Apple Esprit on 12/11/2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

 /*   @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mailField: UITextField!
   
    @IBOutlet weak var errorLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: SigninViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userRepository = UserRepository() // Remplacez par votre implémentation réelle
               viewModel = SigninViewModel(userRepository: userRepository)
               
               // Observer les changements d'état de l'interface utilisateur
               viewModel.$loginUiState
                   .sink { [weak self] state in
                       self?.handleLoginUiState(state)
                   }
                   .store(in: &cancellables)
    }

    @IBAction func loginBtn(_ sender: Any) {
        guard let email = mailField.text, let password = passwordField.text else { return }
                
                // Validation des champs
                var errorMessage: String?
                
                if !viewModel.validateEmail(email) ||
                   !viewModel.validatePassword(password) {
                    if let message = errorMessage {
                        showError(message)
                    }
                    return
                }
                
                // Appeler la méthode de connexion
                viewModel.loginUser(email: email, password: password)
    }
    
    private func handleLoginUiState(_ state: LoginUiState) {
        
            
            if state.isLoggedIn {
                // Navigation vers la prochaine vue ou affichage d'un message de succès
                print("User logged in successfully with token: \(state.token ?? "")")
                // Naviguer vers une autre vue ou effectuer une action appropriée
            } else if let errorMessage = state.errorMessage {
                showError(errorMessage)
                print("hhh")
                //print(errorMessage)
            }
        }
    
    private func showError(_ message: String) {
            errorLabel.text = message
            errorLabel.isHidden = false
        }*/
    
}

