//
//  HistoryViewController.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//

import UIKit

class HistoryViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = HistoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Geçmiş Analizler"
        setupTableView()
        bindViewModel()
        viewModel.fetchHistory()
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onError = { error in
            print("❌ Hata: \(error)")
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(AnalysisHistoryCell.self, forCellReuseIdentifier: AnalysisHistoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnalysisHistoryCell.identifier, for: indexPath) as? AnalysisHistoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.item(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = viewModel.item(at: indexPath.row)
        let detailVC = AnalysisDetailViewController(model: selectedItem)
        navigationController?.pushViewController(detailVC, animated: true)
    }


    // Swipe to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Silinsin mi?", message: "Bu analiz silinecek, emin misiniz?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { _ in
                self.viewModel.deleteItem(at: indexPath.row) { success in
                    completionHandler(success)
                }
            }))
            self.present(alert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
