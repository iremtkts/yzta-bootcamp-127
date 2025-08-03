import Foundation

class SignUpViewModel {
    
    private let authService = AuthService()
    
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
        
        guard let ageInt = Int(age) else {
            onValidationError?("Yaş sayısal olmalı.")
            return
        }
        
      
        signup(name: name, email: email, password: password, age: ageInt, gender: gender)
    }
    
    private func signup(name: String, email: String, password: String, age: Int, gender: String) {
        authService.signup(name: name, email: email, password: password, age: age, gender: gender) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onSignUpSuccess?()
                case .failure(let error):
                    switch error {
                    case .requestFailed(let msg):
                        self?.onValidationError?(msg)
                    default:
                        self?.onValidationError?("Kayıt başarısız")
                    }
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
