//
//  HistoryViewModel.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


class HistoryViewModel {

    var items: [HistoryItem] = [
        HistoryItem(imageName: "no-image", date: "07/2025", diagnosis: "ACNE", confidence: "%90", suggestion: "Cildinizi sabah-akşam temizleyin ve su tüketimini artırın."),
        HistoryItem(imageName: "no-image", date: "07/2025", diagnosis: "Cilt Kuruluğu", confidence: "%85", suggestion: "Günde iki kez nemlendirici uygulayın ve bol su için."),
        HistoryItem(imageName: "no-image", date: "07/2025", diagnosis: "ACNE", confidence: "%92", suggestion: "Yağsız ürünler kullanın ve yüzünüzü günde iki kez yıkayın.")
    ]

    func numberOfItems() -> Int {
        return items.count
    }

    func item(at index: Int) -> HistoryItem {
        return items[index]
    }
}

