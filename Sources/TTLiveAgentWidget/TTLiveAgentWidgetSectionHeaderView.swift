import UIKit

class TTLiveAgentWidgetSectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Views
    
    private let label = UILabel()
    
    // MARK: API
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    // MARK: Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private API

private extension TTLiveAgentWidgetSectionHeaderView {
    
    func setupViews() {
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        let constraints: [NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ]
        constraints.forEach { $0.priority = UILayoutPriority(rawValue: 999) }
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
