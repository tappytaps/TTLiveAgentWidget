import UIKit

class TTLiveAgentTopicViewController: UIViewController {
    
    enum Section {
        case questions(articles: [TTLiveAgentArticle])
        case needHelp
        
        var numberOfRows: Int {
            switch self {
            case let .questions(articles):
                return articles.count
            case .needHelp:
                return 1
            }
        }
        
        var title: String {
            switch self {
            case .questions:
                return TTLiveAgentWidget.shared.strings.questions
            case .needHelp:
                return TTLiveAgentWidget.shared.strings.needMoreHelp
            }
        }
    }
    
    // MARK: Views
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Properties
        
    private let topic: TTLiveAgentTopic
    private var sections: [Section] = []
    
    // MARK: Initialization
    
    init(topic: TTLiveAgentTopic) {
        self.topic = topic
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
        
        sections = [
            .questions(
                articles: TTLiveAgentWidgetDataManager.shared.loadArticles(for: topic)
            ),
            .needHelp
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13.0, *) {} else {
            navigationController?.navigationBar.shadowImage = nil
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TTLiveAgentTopicViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case let .questions(articles):
            let article = articles[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! TTLiveAgentWidgetListCell
            cell.iconImage = TTLiveAgentWidget.shared.images.question
            cell.titleText = article.title
            return cell
        case .needHelp:
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! TTLiveAgentWidgetListCell
            cell.iconImage = TTLiveAgentWidget.shared.images.contactUs
            cell.titleText = TTLiveAgentWidget.shared.strings.contactUs
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! TTLiveAgentWidgetSectionHeaderView
        headerView.text = sections[section].title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case let .questions(articles):
            let article = articles[indexPath.row]
            let articleController = TTLiveAgentArticleViewController(article: article)
            navigationController?.pushViewController(articleController, animated: true)
        case .needHelp:
            TTLiveAgentWidget.shared.openMailComposer(from: self, topicTitle: topic.title)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

// MARK: Private API

private extension TTLiveAgentTopicViewController {
    
    func setupNavigationItem() {
        navigationItem.title = topic.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if isRootController {
            navigationItem.leftBarButtonItem = .closeItem(target: self, action: #selector(closeButtonAction))
        }
    }
    
    func setupViews() {
        extendedLayoutIncludesOpaqueBars = true
        
        tableView.configureWidgetStyle()
        tableView.register(TTLiveAgentWidgetListCell.self, forCellReuseIdentifier: "articleCell")
        tableView.register(TTLiveAgentWidgetListCell.self, forCellReuseIdentifier: "contactUsCell")
        tableView.register(TTLiveAgentWidgetSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
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
    
    @objc func closeButtonAction() {
        dismiss(animated: true)
    }
    
}
