//
//  HomeView.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//

import UIKit

final class HomeView: UIView {

    // MARK: – Scroll & Stack
    private let scrollView  = UIScrollView()
    private let stackView   = UIStackView()

    // MARK: – UI bileşenleri
    let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
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
        let iv = UIImageView(image: UIImage(named: "image"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ANALİZ ET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.backgroundColor = .systemPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "SONUÇLAR"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: – Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureLayout()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: – Layout
    private func configureLayout() {

        // ScrollView ekle
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
         
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
          
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

       
        let headerStack = UIStackView(arrangedSubviews: [logoImageView, titleLabel])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 12

        stackView.addArrangedSubview(headerStack)
        logoImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        stackView.addArrangedSubview(subtitleLabel)

        stackView.addArrangedSubview(uploadImageView)
        uploadImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        stackView.addArrangedSubview(analyzeButton)
        analyzeButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        analyzeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        stackView.addArrangedSubview(resultLabel)
      
        resultLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
