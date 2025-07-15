//
//  AnalysisDetailViewController.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//
import UIKit
import Foundation

final class AnalysisDetailViewController: UIViewController {

    private let detailView = AnalysisDetailView()
    private let model: HistoryItem

    init(model: HistoryItem) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.configure(with: model)
    }
}
