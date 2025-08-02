//
//  UserProfile.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import Foundation

struct UserProfile: Codable {
    let id: Int
    let email: String
    let full_name: String?
    let city: String?
    let age: Int?
    let gender: String?
}
