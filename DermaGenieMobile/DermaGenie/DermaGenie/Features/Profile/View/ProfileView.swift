import UIKit

final class ProfileView: UIView {

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "female")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Düzenle", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let nameField = ProfileView.createTextField(placeholder: "Ad Soyad")
    let ageField = ProfileView.createTextField(placeholder: "Yaş", keyboardType: .numberPad)
    let genderField = ProfileView.createTextField(placeholder: "Cinsiyet")

    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Çıkış Yap", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    static func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = .boldSystemFont(ofSize: 20)
        tf.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.94, alpha: 1)
        tf.textAlignment = .center
        tf.layer.cornerRadius = 12
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = false
        tf.keyboardType = keyboardType
        tf.heightAnchor.constraint(equalToConstant: 58).isActive = true
        return tf
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [editButton, nameField, ageField, genderField])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(stack)
        addSubview(logoutButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalToConstant: 180),

            stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            logoutButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
