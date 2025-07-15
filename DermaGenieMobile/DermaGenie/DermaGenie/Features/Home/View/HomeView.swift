//
//  HomeView.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import UIKit

class HomeView: UIView {

    let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon")) // "icon" = yüz yıkayan emoji
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DermaGenie"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fotoğrafını yükle cildini analiz edelim"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let uploadImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "select-img"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        iv.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.5)
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ANALİZ ET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.backgroundColor = UIColor.systemPurple
        return button
    }()

    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "SONUÇLAR"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(uploadImageView)
        addSubview(analyzeButton)
        addSubview(resultLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            uploadImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            uploadImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 200),
            uploadImageView.heightAnchor.constraint(equalToConstant: 200),

            analyzeButton.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 24),
            analyzeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            analyzeButton.widthAnchor.constraint(equalToConstant: 180),
            analyzeButton.heightAnchor.constraint(equalToConstant: 44),

            resultLabel.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor, constant: 32),
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
