//
//  LoginViewModel.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import Foundation
import Security

class LoginViewModel {
    let userDefault = UserDefaults.standard
    
    let LOGGED_IN_KEY = "isLoggedIn"
    private(set) var isLoggedIn = false
    
    let kEYCHAIN_SERVICE = "keychainService"
    let KEYCHAIN_ACCOUNT = "keychainAccount"
    private(set) var username = ""
    
    init() {
        fetchUserDefault()
        username = fetchUsername() ?? ""
    }
    
    func fetchUserDefault() {
        isLoggedIn = userDefault.bool(forKey: LOGGED_IN_KEY)
    }
    
    func saveLoggedInStatus(loggedIn: Bool) {
        userDefault.set(loggedIn, forKey: LOGGED_IN_KEY)
    }
    
    func fetchUsername() -> String? {
        let query = [
            kSecReturnData: true,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: kEYCHAIN_SERVICE,
            kSecAttrAccount: KEYCHAIN_ACCOUNT,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [CFString : Any] as CFDictionary
                
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess else {
            return nil;
        }
                
        if let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func saveUsername(user: String) {
        username = user
        let savedUsername = fetchUsername()
        if savedUsername != nil {
            updateUserName(user: user)
            return
        }
        let data = user.data(using: .utf8)!
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: kEYCHAIN_SERVICE,
            kSecAttrAccount: KEYCHAIN_ACCOUNT,
        ] as [CFString : Any] as CFDictionary
        SecItemAdd(query, nil)
    }
    
    private func updateUserName(user: String) {
        let data = user.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: kEYCHAIN_SERVICE,
            kSecAttrAccount: KEYCHAIN_ACCOUNT,
        ] as [CFString : Any] as CFDictionary
        let attributes = [
            kSecValueData: data
        ] as CFDictionary
        SecItemUpdate(query, attributes)
    }
}
