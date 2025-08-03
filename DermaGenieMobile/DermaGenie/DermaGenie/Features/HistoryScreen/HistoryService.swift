//
//  HistoryService.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import Foundation

final class HistoryService {
    private let baseURL = APIConfig.baseURL
    
    func deleteAnalysis(id: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            completion(.failure(.requestFailed("Token bulunamadı")))
            return
        }
        
        guard let url = URL(string: "\(baseURL)/ai/delete/\(id)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(.requestFailed("Silme başarısız")))
            }
        }.resume()
    }
    
    func fetchHistory(completion: @escaping (Result<[HistoryItem], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else { return }
        var request = URLRequest(url: URL(string: "https://yzta-bootcamp-127-production-4638.up.railway.app/ai/list")!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    
                    let items: [HistoryItem] = jsonArray.compactMap { dict in
                        let analysisId = dict["analysis_id"] as? String ?? ""
                        let date = dict["created_at"] as? String ?? ""
                        let diagnosis = (dict["detected_classes"] as? [String])?.joined(separator: ", ") ?? ""
                        let annotatedURL = dict["annotated_url"] as? String ?? ""
                        let suggestion = dict["genai_response"] as? String ?? ""
                        let originalURL = dict["original_url"] as? String ?? ""
                        
      
                        let localImageName = "\(Int.random(in: 1...5))"
                        
                        return HistoryItem(
                            analysisId: analysisId,
                            date: date,
                            diagnosis: diagnosis,
                            localImageName: localImageName,
                            annotatedURL: annotatedURL,
                            originalURL: originalURL,
                            suggestion: suggestion,
                           
                        )
                    }
                    
                    completion(.success(items))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
