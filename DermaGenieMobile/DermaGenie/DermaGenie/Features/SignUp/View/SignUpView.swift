import UIKit

class SignUpView: UIView {

    // MARK: - UI Elements

    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DermaGenie"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Kayıt Ol"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let nameField = SignUpView.makeTextField(placeholder: "Ad & Soyad")
    let emailField = SignUpView.makeTextField(placeholder: "E posta")
    let passwordField = SignUpView.makeTextField(placeholder: "Şifreniz", isSecure: true)
    let confirmPasswordField = SignUpView.makeTextField(placeholder: "Şifre Tekrar", isSecure: true)
    let ageField: UITextField = {
        let tf = SignUpView.makeTextField(placeholder: "Yaşınız")
        tf.keyboardType = .numberPad
        return tf
    }()

    let genderField = SignUpView.makeTextField(placeholder: "Cinsiyet")

    let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .systemPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let checkboxLabel: UILabel = {
        let label = UILabel()
        label.text = "Verdiğim bilgilerin doğruluğuna\nTaahhüt Ederim"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kayıt Ol", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var isChecked: Bool = false {
        didSet {
            let imageName = isChecked ? "checkmark.square.fill" : "square"
            checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func toggleCheckbox() {
        isChecked.toggle()
    }

    // MARK: - Layout Setup

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            nameField,
            emailField,
            passwordField,
            confirmPasswordField,
            ageField,
            genderField
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(signUpLabel)
        addSubview(stackView)
        addSubview(checkboxButton)
        addSubview(checkboxLabel)
        addSubview(signUpButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            signUpLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            stackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            checkboxButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            checkboxButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            checkboxLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
            checkboxLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            checkboxLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32),

            signUpButton.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 32),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -32)
        ])
    }

    // MARK: - Helpers

    static func makeTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.isSecureTextEntry = isSecure
        tf.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.96, alpha: 1)
        tf.layer.cornerRadius = 8
        tf.setLeftPaddingPoints(12)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.textColor = .black
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.layer.borderWidth = 1
        return tf
    }
}
