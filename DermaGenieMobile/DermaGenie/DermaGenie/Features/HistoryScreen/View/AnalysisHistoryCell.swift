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
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let diagnosisLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
            
            resultImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            resultImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            resultImageView.widthAnchor.constraint(equalToConstant: 40),
            resultImageView.heightAnchor.constraint(equalToConstant: 40),

            dateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            diagnosisLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            diagnosisLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            diagnosisLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            diagnosisLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with model: HistoryItem) {
        dateLabel.text = formatDate(model.date)
        diagnosisLabel.text = model.diagnosis
        let randomImageName = "\(Int.random(in: 1...5))"
        resultImageView.image = UIImage(named: randomImageName)
    }

    
    private func formatDate(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "tr_TR")
            displayFormatter.dateFormat = "dd/MM/yyyy"
            return displayFormatter.string(from: date)
        }
        return isoDate
    }

}
