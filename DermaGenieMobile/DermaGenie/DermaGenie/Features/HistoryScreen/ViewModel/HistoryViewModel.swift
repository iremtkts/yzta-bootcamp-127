//
//  HistoryViewModel.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import Foundation

final class HistoryViewModel {
    private var items: [HistoryItem] = []
    private let service = HistoryService()

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchHistory() {
        service.fetchHistory { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.items = list
                    self?.onUpdate?()
                case .failure(let error):
                    self?.onError?("\(error)")
                }
            }
        }
    }
    
    func deleteItem(at index: Int, completion: @escaping (Bool) -> Void) {
        let id = items[index].analysisId
        service.deleteAnalysis(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.items.remove(at: index)
                    self?.onUpdate?()
                    completion(true)
                case .failure(let error):
                    self?.onError?("\(error)")
                    completion(false)
                }
            }
        }
    }

    func numberOfItems() -> Int { items.count }
    func item(at index: Int) -> HistoryItem { items[index] }
}
