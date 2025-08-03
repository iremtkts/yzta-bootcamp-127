//
//  HomeViewModel.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import UIKit
import Combine

final class HomeViewModel {

    // Input
    @Published var selectedImage: UIImage?

    // Output
    @Published private(set) var state: State = .idle

    enum State {
        case idle
        case loading
        case result(AnalysisResponse)
        case error(String)
    }

    private var bag = Set<AnyCancellable>()

    init() {
        // View tarafı seçilen resmi yayınlayınca otomatik analiz et
        $selectedImage
            .compactMap { $0 }
            .sink { [weak self] img in self?.analyze(img) }
            .store(in: &bag)
    }

    func reset() { selectedImage = nil; state = .idle }

    private func analyze(_ image: UIImage) {
        state = .loading

        APIService.shared.analyze(image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let res): self?.state = .result(res)
                case .failure(let err): self?.state = .error(err.localizedDescription)
                }
            }
        }
    }
}
