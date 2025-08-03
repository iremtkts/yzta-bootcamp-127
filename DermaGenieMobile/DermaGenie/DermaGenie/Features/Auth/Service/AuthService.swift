
import Foundation

class AuthService {
    
    func login(email: String, password: String, completion: @escaping (Result<String, APIError>) -> Void) {
        print("🔵 [DEBUG] Login başlatıldı")
        print("📩 Email: \(email)")
        
        guard let url = URL(string: APIConfig.baseURL + APIConfig.Endpoints.login) else {
            print("❌ [DEBUG] URL oluşturulamadı")
            completion(.failure(.invalidURL))
            return
        }
        print("🌍 [DEBUG] URL: \(url.absoluteString)")
        
        let params = [
            "username": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        print("📦 [DEBUG] Request Body: \(bodyString)")
        print("📦 [DEBUG] Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [DEBUG] Network error: \(error.localizedDescription)")
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 [DEBUG] Status Code: \(httpResponse.statusCode)")
            } else {
                print("⚠️ [DEBUG] HTTP yanıtı alınamadı")
            }
            
            guard let data = data else {
                print("❌ [DEBUG] Boş response body geldi")
                completion(.failure(.requestFailed("Boş cevap")))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 [DEBUG] Raw Response: \(responseString)")
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let token = json["access_token"] as? String {
                    print("✅ [DEBUG] Token başarıyla alındı: \(token)")
                    completion(.success(token))
                } else {
                    let message = json["detail"] as? String ?? "Giriş başarısız"
                    print("❌ [DEBUG] Token alınamadı, mesaj: \(message)")
                    completion(.failure(.requestFailed(message)))
                }
            } else {
                print("❌ [DEBUG] JSON parse edilemedi")
                completion(.failure(.decodingFailed))
            }
        }
        
        print("🚀 [DEBUG] Request gönderiliyor...")
        task.resume()
    }

    
    func signup(name: String, email: String, password: String, age: Int, gender: String, city: String = "", completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: APIConfig.baseURL + APIConfig.Endpoints.signup) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: Any] = [
            "full_name": name,
            "email": email,
            "password": password,
            "age": age,
            "gender": gender,
            "city": city
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(.requestFailed("JSON encode hatası")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
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
               let message = json["message"] as? String {
                completion(.success(message))
            } else {
                let message = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["detail"] as? String ?? "Kayıt başarısız"
                completion(.failure(.requestFailed(message)))
            }
        }.resume()
    }
    
    func getCurrentUser(completion: @escaping (Result<UserProfile, APIError>) -> Void) {
        guard let url = URL(string: APIConfig.baseURL + APIConfig.Endpoints.currentUser) else {
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
        
        print("🔵 [DEBUG] Kullanıcı bilgisi isteniyor: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [DEBUG] Network error: \(error.localizedDescription)")
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 [DEBUG] Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed("Boş cevap")))
                return
            }
            
            if let jsonStr = String(data: data, encoding: .utf8) {
                print("📄 [DEBUG] Response: \(jsonStr)")
            }
            
            do {
                let user = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }

    func updateUser(fullName: String, age: Int, gender: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: APIConfig.baseURL + "/users/me") else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            completion(.failure(.requestFailed("Token bulunamadı")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH" // PATCH isteği
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
        let body: [String: Any] = [
            "full_name": fullName,
            "city": "",
            "age": age,
            "gender": gender
        ]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = bodyData
        
        print("📤 [DEBUG] PATCH Body: \(body)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 [DEBUG] Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("📄 [DEBUG] Response Body: \(responseString)")
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(.requestFailed("Güncelleme başarısız")))
            }
        }.resume()
    }

}
