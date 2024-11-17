//
//  Auth.swift
//  brichios
//
//  Created by Mac Mini 2 on 17/11/2024.
//

import Foundation
import SwiftKeychainWrapper

class Auth: ObservableObject {
    
    struct Credentials {
        var accessToken: String?
        var refreshToken: String?
        var email: String?
        var password: String?
        var isRemembered: Bool
    }
    
    enum KeychainKey: String {
        case accessToken
        case refreshToken
        case email
        case password
        case isRemembered
    }
    
    static let shared: Auth = Auth()
    private let keychain: KeychainWrapper = KeychainWrapper.standard
    
    @Published var loggedIn: Bool = false
    @Published var rememberedCredentials: Credentials?
    
    private init() {
        loggedIn = hasAccessToken()
        loadRememberedCredentials()
    }
    
     func loadRememberedCredentials() {
            let isRemembered = UserDefaults.standard.bool(forKey: KeychainKey.isRemembered.rawValue)
            
            if isRemembered {
                rememberedCredentials = Credentials(
                    accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
                    refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue),
                    email: keychain.string(forKey: KeychainKey.email.rawValue),
                    password: keychain.string(forKey: KeychainKey.password.rawValue),
                    isRemembered: true
                )
            }
        }
    
    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue),
            email: keychain.string(forKey: KeychainKey.email.rawValue),
            password: keychain.string(forKey: KeychainKey.password.rawValue),
            isRemembered: UserDefaults.standard.bool(forKey: KeychainKey.isRemembered.rawValue)
        )
    }
    
    func setCredentials(accessToken: String, refreshToken: String, email: String?, password: String?, isRemembered: Bool) {
            keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
            keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
            UserDefaults.standard.set(isRemembered, forKey: KeychainKey.isRemembered.rawValue)
            if isRemembered {
                if let email = email {
                    keychain.set(email, forKey: KeychainKey.email.rawValue)
                }
                if let password = password {
                    keychain.set(password, forKey: KeychainKey.password.rawValue)
                }
            } else {
                keychain.removeObject(forKey: KeychainKey.email.rawValue)
                keychain.removeObject(forKey: KeychainKey.password.rawValue)
            }
            loggedIn = true
            loadRememberedCredentials()
        }
    
    func hasAccessToken() -> Bool {
        return getCredentials().accessToken != nil
    }
    
    func getAccessToken() -> String? {
        return getCredentials().accessToken
    }

    func getRefreshToken() -> String? {
        return getCredentials().refreshToken
    }

    func logout() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)
        // Ne supprimez pas les identifiants si "Remember Me" est activé
       if !getCredentials().isRemembered {
           KeychainWrapper.standard.removeObject(forKey: KeychainKey.email.rawValue)
           KeychainWrapper.standard.removeObject(forKey: KeychainKey.password.rawValue)
        }
        loggedIn = false
    }
    
}
