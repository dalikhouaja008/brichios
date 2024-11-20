//
//  localStorage.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
class Auth: ObservableObject {
    
    struct Credentials {
        var accessToken: String?
        var refreshToken: String?
        var email: String?
        var password: String?
        var isRemembered: Bool
    }
    
    enum UserDefaultsKey: String {
        case accessToken
        case refreshToken
        case email
        case password
        case isRemembered
    }
    
    static let shared: Auth = Auth()
    
    @Published var loggedIn: Bool = false
    @Published var rememberedCredentials: Credentials?
    
    private init() {
        loggedIn = hasAccessToken()
        loadRememberedCredentials()
    }
    
    func loadRememberedCredentials() {
        let isRemembered = UserDefaults.standard.bool(forKey: UserDefaultsKey.isRemembered.rawValue)
        
        if isRemembered {
            rememberedCredentials = Credentials(
                accessToken: UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue),
                refreshToken: UserDefaults.standard.string(forKey: UserDefaultsKey.refreshToken.rawValue),
                email: UserDefaults.standard.string(forKey: UserDefaultsKey.email.rawValue),
                password: UserDefaults.standard.string(forKey: UserDefaultsKey.password.rawValue),
                isRemembered: true
            )
        }
    }
    
    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue),
            refreshToken: UserDefaults.standard.string(forKey: UserDefaultsKey.refreshToken.rawValue),
            email: UserDefaults.standard.string(forKey: UserDefaultsKey.email.rawValue),
            password: UserDefaults.standard.string(forKey: UserDefaultsKey.password.rawValue),
            isRemembered: UserDefaults.standard.bool(forKey: UserDefaultsKey.isRemembered.rawValue)
        )
    }
    
    func setCredentials(accessToken: String, refreshToken: String, email: String?, password: String?, isRemembered: Bool) {
        UserDefaults.standard.set(accessToken, forKey: UserDefaultsKey.accessToken.rawValue)
        UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKey.refreshToken.rawValue)
        UserDefaults.standard.set(isRemembered, forKey: UserDefaultsKey.isRemembered.rawValue)
        if isRemembered {
            if let email = email {
                UserDefaults.standard.set(email, forKey: UserDefaultsKey.email.rawValue)
            }
            if let password = password {
                UserDefaults.standard.set(password, forKey: UserDefaultsKey.password.rawValue)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.email.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.password.rawValue)
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
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.refreshToken.rawValue)
       // if !getCredentials().isRemembered {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.email.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.password.rawValue)
        //}
        loggedIn = false
    }
    
}

