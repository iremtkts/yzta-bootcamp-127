//
//  AnalysisHistoryCell.swift
//  DermaGenie
//
//  Created by iremt on 15.07.2025.
//


import UIKit

class AnalysisHistoryCell: UITableViewCell {
    
    static let identifier = "AnalysisHistoryCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.92, blue: 0.96, alpha: 1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let resultImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.systemPurple
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let diagnosisLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium) 
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(cardView)
        cardView.addSubview(resultImageView)
        cardView.addSubview(dateLabel)
        cardView.addSubview(diagnosisLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            resultImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            resultImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            resultImageView.widthAnchor.constraint(equalToConstant: 60),
            resultImageView.heightAnchor.constraint(equalToConstant: 60),
            
            resultImageView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16),

      
            dateLabel.centerYAnchor.constraint(equalTo: resultImageView.centerYAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            diagnosisLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            diagnosisLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            diagnosisLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
        ])
    }
    
    func configure(with model: HistoryItem) {
        dateLabel.text = model.date
        diagnosisLabel.text = model.diagnosis
        resultImageView.image = UIImage(named: "no-image")

    }
}
