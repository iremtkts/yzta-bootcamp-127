//
//  APIError 2.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//

//  APIError.swift
import Foundation

enum APIError: Error {
    // Ağ & adres
    case invalidURL
    case requestFailed(String)      // sunucudan veya network'ten dönen hata mesajı

    // Decode / business
    case decodingFailed
    case invalidResponse            // beklenen formatta değil

    // Genel (SDK hatası vs.)
    case server(Error)              // orijinal Error'u sarmalar
}
