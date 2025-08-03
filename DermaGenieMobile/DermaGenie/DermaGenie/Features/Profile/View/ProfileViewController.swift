import UIKit

final class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    private var isEditingFields = false
    private let genderPicker = UIPickerView()
    private let genderOptions = ["Kadın", "Erkek"]
    private let authService = AuthService()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profil"
        configureFields()
        configureImage()
        configureEditButton()
        configureGenderPicker()
        setupLogoutAction()

        profileView.ageField.delegate = self
        profileView.genderField.delegate = self
    }

    private func configureFields() {
        let name = UserDefaults.standard.string(forKey: "name") ?? "İsim"
        let age = UserDefaults.standard.string(forKey: "age") ?? ""
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        profileView.nameField.text = name
        profileView.ageField.text = age
        profileView.genderField.text = gender
        configureImage()
        
        fetchUserProfile()
    }

    private func fetchUserProfile() {
        authService.getCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.profileView.nameField.text = user.full_name ?? ""
                    if let age = user.age {
                        self?.profileView.ageField.text = "\(age)"
                    }
                    self?.profileView.genderField.text = user.gender ?? ""
                    
                    UserDefaults.standard.setValue(user.full_name, forKey: "name")
                    UserDefaults.standard.setValue(user.age != nil ? "\(user.age!)" : "", forKey: "age")
                    UserDefaults.standard.setValue(user.gender, forKey: "gender")
                    
                    self?.configureImage()
                    
                case .failure(let error):
                    print("❌ Kullanıcı bilgisi alınamadı: \(error)")
                }
            }
        }
    }

    private func configureImage() {
        let gender = profileView.genderField.text?.lowercased() ?? ""
        let imageName: String
        if gender.contains("erkek") || gender.contains("male") {
            imageName = "male"
        } else {
            imageName = "female"
        }
        profileView.imageView.image = UIImage(named: imageName)
    }

    private func configureEditButton() {
        profileView.editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
    }

    private func configureGenderPicker() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        profileView.genderField.inputView = genderPicker
        profileView.genderField.tintColor = .clear

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(doneSelectingGender))
        toolbar.setItems([done], animated: false)
        profileView.genderField.inputAccessoryView = toolbar
    }

    @objc private func doneSelectingGender() {
        profileView.genderField.resignFirstResponder()
        configureImage()
    }

    @objc private func toggleEditMode() {
        isEditingFields.toggle()

        profileView.nameField.isUserInteractionEnabled = isEditingFields
        profileView.ageField.isUserInteractionEnabled = isEditingFields
        profileView.genderField.isUserInteractionEnabled = isEditingFields
        profileView.ageField.keyboardType = .numberPad

        profileView.editButton.setTitle(isEditingFields ? "Kaydet" : "Düzenle", for: .normal)

        if !isEditingFields {
            guard let name = profileView.nameField.text, !name.isEmpty,
                  let ageText = profileView.ageField.text, let age = Int(ageText),
                  let gender = profileView.genderField.text, !gender.isEmpty else {
                print("⚠️ [DEBUG] Alanlar eksik")
                return
            }
            
            authService.updateUser(fullName: name, age: age, gender: gender) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("✅ [DEBUG] Profil güncellendi")
                        UserDefaults.standard.setValue(name, forKey: "name")
                        UserDefaults.standard.setValue("\(age)", forKey: "age")
                        UserDefaults.standard.setValue(gender, forKey: "gender")
                        self?.configureImage()
                    case .failure(let error):
                        print("❌ [DEBUG] Profil güncelleme hatası: \(error)")
                    }
                }
            }
        }
    }

    private func setupLogoutAction() {
        profileView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    @objc private func logoutTapped() {
        ["access_token", "name", "age", "gender"].forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }

        let loginVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navVC
        }
    }
}

// MARK: - Gender Picker
extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { genderOptions.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { genderOptions[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profileView.genderField.text = genderOptions[row]
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == profileView.ageField {
            let allowed = CharacterSet.decimalDigits
            return CharacterSet(charactersIn: string).isSubset(of: allowed)
        }
        if textField == profileView.genderField {
            return false
        }
        return true
    }
}
