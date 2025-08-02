//
//  APIConfig.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import Foundation

struct APIConfig {
    static let baseURL = "https://yzta-bootcamp-127-production-f425.up.railway.app"
}

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}

import Foundation

class AuthService {
    
    func login(email: String, password: String, completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/auth/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let params = [
            "username": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed("Boş cevap")))
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let token = json["access_token"] as? String {
                completion(.success(token))
            } else {
                let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["detail"] as? String ?? "Giriş başarısız"
                completion(.failure(.requestFailed(message)))
            }
        }.resume()
    }
    
    
    func getCurrentUser(completion: @escaping (Result<UserProfile, APIError>) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/users/me") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            completion(.failure(.requestFailed("Token bulunamadı")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed("Boş cevap")))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
