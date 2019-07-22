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
        layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        let constraints: [NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ]
        constraints.forEach { $0.priority = UILayoutPriority(rawValue: 999) }
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
