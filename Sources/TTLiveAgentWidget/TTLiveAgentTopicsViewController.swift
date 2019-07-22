import UIKit

class TTLiveAgentTopicsViewController: UIViewController {
    
    enum Topic {
        case liveAgent(topic: TTLiveAgentTopic)
        case other
        
        var image: UIImage? {
            switch self {
            case let .liveAgent(topic):
                return topic.image
            case .other:
                return TTLiveAgentWidget.shared.images.other
            }
        }
        
        var title: String {
            switch self {
            case let .liveAgent(topic):
                return topic.title
            case .other:
                return TTLiveAgentWidget.shared.strings.other
            }
        }
    }
    
    // MARK: Views
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Properties
    
    private let topics: [Topic]
    
    // MARK: Initialization
    
    init(topics: [TTLiveAgentTopic]) {
        self.topics = topics.map { .liveAgent(topic: $0) } + [.other]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationItem()
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TTLiveAgentTopicsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = topics[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! TTLiveAgentWidgetListCell
        cell.iconImage = topic.image
        cell.titleText = topic.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        switch topic {
        case let .liveAgent(topic):
             let topicController = TTLiveAgentTopicViewController(topic: topic)
             navigationController?.pushViewController(topicController, animated: true)
        case .other:
            let otherController = TTLiveAgentWidgetOtherViewController()
            navigationController?.pushViewController(otherController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

// MARK: Private API

private extension TTLiveAgentTopicsViewController {
    
    func setupNavigationItem() {
        navigationItem.title = TTLiveAgentWidget.shared.strings.widgetTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if isRootController {
            navigationItem.leftBarButtonItem = .closeItem(target: self, action: #selector(closeButtonAction))
        }
    }
    
    func setupViews() {
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.configureWidgetStyle()
        tableView.estimatedSectionHeaderHeight = 64
        tableView.register(TTLiveAgentWidgetListCell.self, forCellReuseIdentifier: "topicCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 13.0, *) {} else {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        }
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func closeButtonAction() {
        dismiss(animated: true)
    }
    
}

