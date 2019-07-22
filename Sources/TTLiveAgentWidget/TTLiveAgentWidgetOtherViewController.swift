import UIKit

class TTLiveAgentWidgetOtherViewController: UIViewController {
    
    enum Item {
        case privacyPolicy
        case rate
        case contactUs
        
        var image: UIImage? {
            switch self {
            case .privacyPolicy:
                return TTLiveAgentWidget.shared.images.privacyPolicy
            case .rate:
                return TTLiveAgentWidget.shared.images.rate
            case .contactUs:
                return TTLiveAgentWidget.shared.images.contactUs
            }
        }
        
        var title: String {
            switch self {
            case .privacyPolicy:
                return TTLiveAgentWidget.shared.strings.privacyPolicy
            case .rate:
                return TTLiveAgentWidget.shared.strings.rate
            case .contactUs:
                return TTLiveAgentWidget.shared.strings.contactUs
            }
        }
    }
    
    // MARK: Views
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Properties
    
    private var items: [Item] = [
        .privacyPolicy,
        .rate,
        .contactUs
    ]
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupViews()
    }
    
}

extension TTLiveAgentWidgetOtherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TTLiveAgentWidgetListCell
        cell.iconImage = item.image
        cell.titleText = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case .privacyPolicy:
            debugPrint("TODO")
        case .rate:
            TTLiveAgentWidget.shared.openRateApp()
        case .contactUs:
            TTLiveAgentWidget.shared.openMailComposer(from: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

// MARK: - Private API

private extension TTLiveAgentWidgetOtherViewController {
    
    func setupNavigationItem() {
        navigationItem.title = TTLiveAgentWidget.shared.strings.other
    }
    
    func setupViews() {
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.configureWidgetStyle()
        tableView.register(TTLiveAgentWidgetListCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}
