import Foundation

struct APIConfig {
   
    static let baseURL = "https://yzta-bootcamp-127-production-4638.up.railway.app"
    
   
    struct Endpoints {
        static let signup = "/auth/signup"
        static let login = "/auth/login"
        static let currentUser = "/users/me"
        static let analyzeImage  = "/ai/analyze-image"
    }
}
