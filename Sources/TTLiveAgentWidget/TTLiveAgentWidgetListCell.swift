import UIKit

class TTLiveAgentWidgetListCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bottomSeparator = UIView()
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TTLiveAgentWidgetListCell {
    
    func setupViews() {
        backgroundView = UIView()
        if #available(iOS 13.0, *) {
            backgroundView?.backgroundColor = .systemBackground
        }
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(white: 0, alpha: 0.04)
        
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        accessoryType = .disclosureIndicator
        
        if #available(iOS 13.0, *) {
            bottomSeparator.backgroundColor = .systemFill
        } else {
            bottomSeparator.backgroundColor = UIColor(white: 0, alpha: 0.08)
        }
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        
        let contentStackView = UIStackView()
        contentStackView.axis = .horizontal
        contentStackView.spacing = 16
        contentStackView.alignment = .center
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(contentStackView)
        addSubview(bottomSeparator)

        NSLayoutConstraint.activate([
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
}
