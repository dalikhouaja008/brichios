//
//  SplashScreenView.swift
//  brichios
//
//  Created by Mac Mini 2 on 24/11/2024.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var size = 0.5
    @State private var opacity = 0.5
    @EnvironmentObject var auth: Auth
    @StateObject private var biometricAuth = BiometricAuthManager()
    @AppStorage("rememberMe") private var rememberMe = false
    //@State private var rememberMe = UserDefaults.standard.bool(forKey: Auth.UserDefaultsKey.isRemembered.rawValue)

    var body: some View {
        
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("logo")
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.7
                        self.opacity = 1.00
                    }
                }
            }
            .onAppear {
                print(rememberMe)
                if rememberMe {
                                biometricAuth.authenticateUser { success in
                                    if success {
                                        // Authentification réussie, procéder à la connexion automatique
                                        auth.loggedIn = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            withAnimation {
                                                self.isActive = true
                                            }
                                        }
                                    } else {
                                        // Gérer l'échec de l'authentification si nécessaire
                                        print("Biometric authentication failed")
                                    }
                                }
                            } else {
                                // Si "Remember Me" n'est pas coché, activer le contenu après un délai.
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    withAnimation {
                                        self.isActive = true
                                    }
                                }
                            }
                        }
                        .alert(item: Binding(
                            get: { biometricAuth.biometricError.map { BiometricError(message: $0) } },
                            set: { _ in biometricAuth.biometricError = nil }
                        )) { error in
                            Alert(
                                title: Text("Authentication problem"),
                                message: Text(error.message),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("Color1"))
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            }
           
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(Auth.shared) // Ajoutez un environnement pour les aperçus si nécessaire
    }
}



