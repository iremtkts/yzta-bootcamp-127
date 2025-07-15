//
//  LoginViewModel.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import Foundation

class LoginViewModel {
    
    
    var onError: ((String) -> Void)?
    var onLoginSuccess: (() -> Void)?
    
    func login(email: String, password: String) {
        guard !email.isEmpty else {
            onError?("Lütfen e-posta adresinizi girin.")
            return
        }

        guard isValidEmail(email) else {
            onError?("Geçerli bir e-posta adresi giriniz.")
            return
        }

        guard !password.isEmpty else {
            onError?("Lütfen şifrenizi girin.")
            return
        }

        
        print("✅ Giriş başarılı! Email: \(email), Şifre: \(password)")
        onLoginSuccess?()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    
}
