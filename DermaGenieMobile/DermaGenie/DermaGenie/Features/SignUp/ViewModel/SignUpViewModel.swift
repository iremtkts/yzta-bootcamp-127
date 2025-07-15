//
//  SignUpViewModel.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import Foundation

class SignUpViewModel {

    var onValidationError: ((String) -> Void)?
    var onSignUpSuccess: (() -> Void)?

    func validateForm(name: String,
                      email: String,
                      password: String,
                      confirmPassword: String,
                      age: String,
                      gender: String,
                      isChecked: Bool) {

        guard !name.isEmpty else {
            onValidationError?("Lütfen adınızı ve soyadınızı girin.")
            return
        }

        guard !email.isEmpty else {
            onValidationError?("Lütfen e-posta adresinizi girin.")
            return
        }

        guard isValidEmail(email) else {
            onValidationError?("Geçerli bir e-posta adresi giriniz.")
            return
        }

        guard !password.isEmpty && !confirmPassword.isEmpty else {
            onValidationError?("Lütfen şifrenizi ve tekrarını girin.")
            return
        }

        guard password == confirmPassword else {
            onValidationError?("Şifreler uyuşmuyor.")
            return
        }

        guard !age.isEmpty else {
            onValidationError?("Lütfen yaşınızı girin.")
            return
        }

        guard !gender.isEmpty else {
            onValidationError?("Lütfen cinsiyet seçin.")
            return
        }

        guard isChecked else {
            onValidationError?("Devam etmek için taahhüt kutusunu onaylayın.")
            return
        }

        onSignUpSuccess?()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
