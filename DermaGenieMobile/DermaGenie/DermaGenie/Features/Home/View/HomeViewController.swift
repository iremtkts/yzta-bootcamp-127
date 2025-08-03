//
//  HomeViewController.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import UIKit
import PhotosUI
import Combine

final class HomeViewController: UIViewController {

    private let contentView = HomeView()
    private let vm         = HomeViewModel()
    private var bag        = Set<AnyCancellable>()

    // MARK: – Lifecycle
    override func loadView() { view = contentView }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
        bindViewModel()
    }

    // MARK: – User actions
    private func configureActions() {
        // Görsele tıkla → picker
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        contentView.uploadImageView.isUserInteractionEnabled = true
        contentView.uploadImageView.addGestureRecognizer(tap)

        // Buton
        contentView.analyzeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        switch vm.state {
        case .idle      : selectPhoto()
        case .result, .error: vm.reset()
        case .loading   : break // devre dışı
        }
    }

    // MARK: – Bindings
    private func bindViewModel() {
        vm.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in self?.render(state) }
            .store(in: &bag)
    }

    private func render(_ state: HomeViewModel.State) {
        switch state {

        case .idle:
            contentView.resultLabel.text = "SONUÇLAR"
            contentView.uploadImageView.image = UIImage(named: "image")
            contentView.analyzeButton.setTitle("ANALİZ ET", for: .normal)
            contentView.analyzeButton.isEnabled = true

        case .loading:
            contentView.analyzeButton.setTitle("Analiz ediliyor…", for: .normal)
            contentView.analyzeButton.isEnabled = false

        case .result(let res):
            let classes = res.diagnoses.joined(separator: ", ")
            contentView.resultLabel.text = "Tespit edilenler: \(classes)\n\n\(res.suggestion)"

            contentView.analyzeButton.setTitle("TEKRAR DENE", for: .normal)
            contentView.analyzeButton.isEnabled = true

        case .error(let msg):
            contentView.resultLabel.text = "⚠️ \(msg)"
            contentView.analyzeButton.setTitle("TEKRAR DENE", for: .normal)
            contentView.analyzeButton.isEnabled = true
        }
    }

    // MARK: – Photo picker
    @objc private func selectPhoto() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: – PHPicker delegate
extension HomeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] img, _ in
            guard let self, let image = img as? UIImage else { return }
            DispatchQueue.main.async {
                self.contentView.uploadImageView.image = image
                self.vm.selectedImage = image
            }
        }
    }
}
