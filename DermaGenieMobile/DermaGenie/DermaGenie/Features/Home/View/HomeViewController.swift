//
//  HomeViewController.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import UIKit

class HomeViewController: UIViewController {

    private let homeView = HomeView()

    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.analyzeButton.addTarget(self, action: #selector(handleAnalyze), for: .touchUpInside)
    }

    @objc private func handleAnalyze() {
        print("Analiz başlatıldı!") 
    }
}
