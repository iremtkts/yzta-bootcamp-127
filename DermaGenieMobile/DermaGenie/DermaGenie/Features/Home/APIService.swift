//
//  APIError.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import UIKit

final class APIService {

    static let shared = APIService()
    private init() {}

    func analyze(image: UIImage,
                 completion: @escaping (Result<AnalysisResponse, APIError>) -> Void) {

        guard let jpeg = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(.invalidResponse)); return
        }

        let url = URL(string: APIConfig.baseURL + APIConfig.Endpoints.analyzeImage)!
        let boundary = UUID().uuidString

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = makeBody(data: jpeg,
                                    mime: "image/jpeg",
                                    field: "file",
                                    filename: "photo.jpg",
                                    boundary: boundary)

        URLSession.shared.dataTask(with: request) { data, _, err in
            if let err { completion(.failure(.server(err))); return }

            guard let data,
                  let obj = try? JSONDecoder().decode(AnalysisResponse.self, from: data)
            else { completion(.failure(.invalidResponse)); return }

            completion(.success(obj))
        }.resume()
    }

    // MARK: – Helpers
    private func makeBody(data: Data,
                          mime: String,
                          field: String,
                          filename: String,
                          boundary: String) -> Data {

        var body = Data()
        let nl = "\r\n"

        body.append("--\(boundary)\(nl)")
        body.append("Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(filename)\"\(nl)")
        body.append("Content-Type: \(mime)\(nl)\(nl)")
        body.append(data)
        body.append("\(nl)--\(boundary)--\(nl)")

        return body
    }
}


private extension Data {
    mutating func append(_ string: String) {
        if let d = string.data(using: .utf8) { append(d) }
    }
}
