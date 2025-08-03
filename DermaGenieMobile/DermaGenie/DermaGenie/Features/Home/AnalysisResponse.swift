//
//  AnalysisResponse.swift
//  DermaGenie
//
//  Created by iremt on 3.08.2025.
//


import Foundation

struct AnalysisResponse: Decodable {
    let diagnosis: String
    let confidence: Double
    let suggestion: String
}
