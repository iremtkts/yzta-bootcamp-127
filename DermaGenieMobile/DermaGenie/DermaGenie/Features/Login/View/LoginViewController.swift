//
//  LoginViewController.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()

    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(goToSignUp))
        loginView.registerLabel.addGestureRecognizer(registerTap)

    }
    
    @objc private func goToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    
    private func setupBindings() {
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(title: "Hata", message: errorMessage)
            }
        }

        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Başarılı", message: "Giriş başarılı!")
            }
        }
    }

    
    @objc private func handleLogin() {
        let email = loginView.emailTextField.text ?? ""
        let password = loginView.passwordTextField.text ?? ""
        viewModel.login(email: email, password: password)
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                let tabBarController = MainTabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                self?.present(tabBarController, animated: true, completion: nil)
            }
        }

    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
