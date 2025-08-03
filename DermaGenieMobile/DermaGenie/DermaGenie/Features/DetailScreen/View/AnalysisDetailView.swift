import UIKit
import SDWebImage

class AnalysisDetailView: UIView {

    let scrollView = UIScrollView()
    let stackView = UIStackView()

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let diagnosisLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let confidenceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let suggestionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "💡 Gemini Önerisi"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let suggestionBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 250/255, green: 240/255, blue: 240/255, alpha: 1)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        // ScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // StackView constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

     
        suggestionBox.addSubview(suggestionLabel)
        NSLayoutConstraint.activate([
            suggestionLabel.topAnchor.constraint(equalTo: suggestionBox.topAnchor, constant: 12),
            suggestionLabel.bottomAnchor.constraint(equalTo: suggestionBox.bottomAnchor, constant: -12),
            suggestionLabel.leadingAnchor.constraint(equalTo: suggestionBox.leadingAnchor, constant: 12),
            suggestionLabel.trailingAnchor.constraint(equalTo: suggestionBox.trailingAnchor, constant: -12)
        ])

        // Add arranged subviews
        stackView.addArrangedSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.25).isActive = true

        stackView.addArrangedSubview(calendarLabel)
        stackView.addArrangedSubview(diagnosisLabel)
        stackView.addArrangedSubview(confidenceLabel)
        stackView.setCustomSpacing(30, after: confidenceLabel)

        stackView.addArrangedSubview(suggestionTitleLabel)
        stackView.addArrangedSubview(suggestionBox)
    }

    


    func configure(with model: HistoryItem) {
      
        calendarLabel.text  = "📅 \(formatDate(model.date))"
        diagnosisLabel.text = model.diagnosis
        suggestionLabel.text = model.suggestion

        
        let placeholder = UIImage(named: "no-image")
        guard let annotatedURL = URL(string: model.annotatedURL),
              let originalURL  = URL(string: model.originalURL) else {
            imageView.image = placeholder
            return
        }

      
        imageView.sd_setImage(
            with: annotatedURL,
            placeholderImage: placeholder,
            options: [.continueInBackground, .highPriority]
        ) { [weak self] _, error, _, _ in
            guard error != nil else { return }   
            self?.imageView.sd_setImage(
                with: originalURL,
                placeholderImage: placeholder,
                options: [.continueInBackground, .highPriority]
            )
        }
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
