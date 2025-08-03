//
//  APIError 2.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import Foundation

enum APIError: Error {
    case invalidResponse
    case server(Error)
}
