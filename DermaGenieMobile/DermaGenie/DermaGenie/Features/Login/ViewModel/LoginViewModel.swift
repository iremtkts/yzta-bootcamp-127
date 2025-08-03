import Foundation

class LoginViewModel {
    
    private let authService = AuthService()
    
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
        
    
        authService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                UserDefaults.standard.set(token, forKey: "access_token")
                self?.fetchCurrentUser()
            case .failure(let error):
                switch error {
                case .requestFailed(let msg):
                    self?.onError?(msg)
                default:
                    self?.onError?("Giriş başarısız")
                }
            }
        }
    }
    
    private func fetchCurrentUser() {
        authService.getCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserDefaults.standard.set(user.id, forKey: "user_id")
                    self?.onLoginSuccess?()
                case .failure(let error):
                    switch error {
                    case .requestFailed(let msg):
                        self?.onError?(msg)
                    default:
                        self?.onError?("Kullanıcı bilgisi alınamadı")
                    }
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx =
        #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
