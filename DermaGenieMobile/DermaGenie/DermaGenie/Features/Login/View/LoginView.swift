import UIKit

class LoginView: UIView {
    // MARK: - Gradient container
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()

    // MARK: - UI Elements
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "DermaGenie"
        lbl.font = .systemFont(ofSize: 28, weight: .semibold)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.setLeftPaddingPoints(12)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(
            string: "EMAIL",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.setLeftPaddingPoints(12)
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(
            string: "ŞİFRE",
            attributes: [.foregroundColor: UIColor.darkGray]
        )
        return tf
    }()

    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Giriş Yap", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 70/255, alpha: 1) // lacivert
        btn.layer.cornerRadius = 22
        return btn
    }()

    let registerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Hesabın henüz yok mu?\nKayıt Ol!"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .white
        lbl.isUserInteractionEnabled = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = .white
        clipsToBounds = true

    
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(gradientView, at: 0)

        [imageView, titleLabel, emailTextField, passwordTextField, loginButton, registerLabel].forEach {
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            // Logo & Title
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 140),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Form fields
            emailTextField.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 120),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),

            // Gradient region includes form components
            gradientView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Register Label
            registerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            registerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func setupGradientLayer() {

        let navyColor = UIColor(red: 0/255, green: 0/255, blue: 70/255, alpha: 1).cgColor
        gradientLayer.colors = [UIColor.systemPurple.cgColor,navyColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds


        let w = gradientView.bounds.width
        let h = gradientView.bounds.height
        let topArc: CGFloat = 50
        let bottomArc: CGFloat = 0

        let path = UIBezierPath()
        // Top curve
        path.move(to: CGPoint(x: 0, y: topArc))
        path.addQuadCurve(
            to: CGPoint(x: w, y: topArc),
            controlPoint: CGPoint(x: w/2, y: -topArc/2)
        )
        // Right edge
        path.addLine(to: CGPoint(x: w, y: h - bottomArc))
        // Bottom flat edge
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h - bottomArc),
            controlPoint: CGPoint(x: w/2, y: h + bottomArc)
        )
        path.close()

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        gradientView.layer.mask = maskLayer
    }
}

// MARK: - Padding Extension
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
