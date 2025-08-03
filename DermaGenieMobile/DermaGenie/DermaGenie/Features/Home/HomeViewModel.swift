import UIKit
import Combine

@MainActor
final class HomeViewModel {

    // MARK: - Inputs
    @Published var selectedImage: UIImage?

    // MARK: - Outputs
    @Published private(set) var state: State = .idle
    @Published private(set) var history: [AnalysisResult] = []

    enum State {
        case idle
        case loading
        case result(AnalysisResult)
        case error(String)
    }

    private var bag = Set<AnyCancellable>()
    private var currentTask: URLSessionDataTask?

    init() {
        $selectedImage
            .compactMap { $0 }
            .sink { [weak self] image in
                self?.analyze(image)
            }
            .store(in: &bag)
    }

    func reset() {
        currentTask?.cancel()
        selectedImage = nil
        state = .idle
    }

    // MARK: - Private
    private func analyze(_ image: UIImage) {
        state = .loading

        currentTask = APIService.shared.analyze(image: image) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                let resultData = AnalysisResult(
                    image: image,
                    diagnoses: response.diagnoses,
                    suggestion: response.suggestion
                )
                self.history.append(resultData) // geçmişe ekle
                self.state = .result(resultData)

            case .failure(let apiError):
                let message: String
                switch apiError {
                case .invalidURL:            message = "Sunucu adresi geçersiz."
                case .decodingFailed:        message = "Yanıt çözümlenemedi."
                case .requestFailed(let m):  message = m
                default:                     message = "Beklenmeyen hata."
                }
                self.state = .error(message)
            }
        }
    }
}
