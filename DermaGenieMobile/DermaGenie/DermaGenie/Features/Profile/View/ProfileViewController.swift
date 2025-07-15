import UIKit

final class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    private var isEditingFields = false
    private let genderPicker = UIPickerView()
    private let genderOptions = ["Kadın", "Erkek"]

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
        let name = UserDefaults.standard.string(forKey: "name") ?? "İrem Tektas"
        let age = UserDefaults.standard.string(forKey: "age") ?? "24"
        let gender = UserDefaults.standard.string(forKey: "gender") ?? "Kadın"

        profileView.nameField.text = name
        profileView.ageField.text = age
        profileView.genderField.text = gender
    }

    private func configureImage() {
        let gender = profileView.genderField.text?.lowercased() ?? "kadın"
        let imageName = (gender == "erkek" || gender == "male") ? "male" : "female"
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
            UserDefaults.standard.setValue(profileView.nameField.text, forKey: "name")
            UserDefaults.standard.setValue(profileView.ageField.text, forKey: "age")
            UserDefaults.standard.setValue(profileView.genderField.text, forKey: "gender")
            configureImage()
        }
    }

    private func setupLogoutAction() {
        profileView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    @objc private func logoutTapped() {
        ["token", "name", "age", "gender"].forEach {
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

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genderOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        genderOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profileView.genderField.text = genderOptions[row]
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == profileView.ageField {
            // Sadece rakamlar
            let allowed = CharacterSet.decimalDigits
            return CharacterSet(charactersIn: string).isSubset(of: allowed)
        }
        if textField == profileView.genderField {
            return false
        }
        return true
    }
}
