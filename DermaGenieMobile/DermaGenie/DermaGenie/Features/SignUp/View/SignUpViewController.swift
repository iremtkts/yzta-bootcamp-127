//
//  SignUpViewController.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import UIKit

class SignUpViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = SignUpView()
    private let viewModel = SignUpViewModel()
    private let genderOptions = ["Kadın", "Erkek"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupGenderFieldTap()
        setupSignUpButtonAction()
        setupViewModelBindings()
        hideKeyboardWhenTappedAround()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight + 20
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 20
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    private func setupScrollView() {
        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

          
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
    }


    private func setupGenderFieldTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showGenderOptions))
        contentView.genderField.isUserInteractionEnabled = true
        contentView.genderField.addGestureRecognizer(tapGesture)
    }

    @objc private func showGenderOptions() {
        let alert = UIAlertController(title: "Cinsiyet Seçin", message: nil, preferredStyle: .actionSheet)

        for gender in genderOptions {
            alert.addAction(UIAlertAction(title: gender, style: .default, handler: { _ in
                self.contentView.genderField.text = gender
            }))
        }

        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = contentView.genderField
            popoverController.sourceRect = CGRect(x: contentView.genderField.bounds.midX, y: contentView.genderField.bounds.maxY, width: 0, height: 0)
        }

        present(alert, animated: true, completion: nil)
    }

    private func setupSignUpButtonAction() {
        contentView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }

    @objc private func handleSignUp() {
        viewModel.validateForm(
            name: contentView.nameField.text ?? "",
            email: contentView.emailField.text ?? "",
            password: contentView.passwordField.text ?? "",
            confirmPassword: contentView.confirmPasswordField.text ?? "",
            age: contentView.ageField.text ?? "",
            gender: contentView.genderField.text ?? "",
            isChecked: contentView.isChecked
        )
    }

    private func setupViewModelBindings() {
        viewModel.onValidationError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(message)
            }
        }

        viewModel.onSignUpSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert("Kayıt başarılı! (Simülasyon)")
            }
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension SignUpViewController: UIGestureRecognizerDelegate {}
