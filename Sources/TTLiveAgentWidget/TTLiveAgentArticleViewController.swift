import UIKit
import WebKit

class TTLiveAgentArticleViewController: UIViewController {
    
    // MARK: Views
    
    private let webView = WKWebView()
    
    // MARK: Properties
        
    private let article: TTLiveAgentArticle
    
    // MARK: Initialization
    
    init(article: TTLiveAgentArticle) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupViews()
        
        loadArticle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {} else {
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    override internal func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        loadArticle()
    }
    
}

// MARK: - Private API

private extension TTLiveAgentArticleViewController {
    
    func setupNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        if #available(iOS 13.0, *) {
            let standardAppearance = UINavigationBarAppearance()
            standardAppearance.configureWithOpaqueBackground()
            standardAppearance.shadowColor = .clear
            navigationItem.standardAppearance = standardAppearance
        }
        if isRootController {
            navigationItem.leftBarButtonItem = .closeItem(target: self, action: #selector(closeButtonAction))
        }
    }
    
    func setupViews() {
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(webView)
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func loadArticle() {
        let backgroundColor: UIColor
        let titleColor: UIColor
        let contentColor: UIColor
        
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
            titleColor = .label
            contentColor = .secondaryLabel
        } else {
            backgroundColor = .white
            titleColor = .black
            contentColor = UIColor(white: 0, alpha: 0.54)
        }
        
        let htmlTemplate = """
            <html>
            <head>
                <meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'>
                <style>
                    *{-webkit-text-size-adjust: none;}
                    html{overflow-x: hidden; background-color: %@;}
                    body{overflow-x: hidden; padding: 8; font-family: '-apple-system';}
                    a{color: %@ !important;}
                    h1{font-size: 20px; line-height: 24px; letter-spacing: 0.38px; color: %@ !important;}
                    h3{font-size: 17px; line-height: 22px; letter-spacing: -0.41px; color: %@ !important;}
                    #content{font-size: 17px; line-height: 22px; letter-spacing: -0.41px;  color: %@ !important;}
                </style>
            </head>
                <body>
                    <h1 id="title">%@</h1>
                    <div id="content">%@</div>
                </body>
            </html>
        """
        
        let html = String(
            format: htmlTemplate,
            hexString(from: backgroundColor),
            hexString(from: view.tintColor),
            hexString(from: titleColor),
            hexString(from: titleColor),
            hexString(from: contentColor),
            article.title,
            article.content
        )
        
        webView.loadHTMLString(html, baseURL: TTLiveAgentWidget.shared.baseUrl)
    }
    
    func hexString(from color: UIColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format: "#%02x%02x%02x%02x", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
    
    @objc func closeButtonAction() {
        dismiss(animated: true)
    }
    
}

// MARK: - WKNavigationDelegate

extension TTLiveAgentArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            if let url = navigationAction.request.url {
                let dataManager = TTLiveAgentWidgetDataManager.shared
                if let urlCode = TTLiveAgentUtils.urlCode(from: url), let article = dataManager.articleForUrlCode(urlCode) {
                    let articleController = TTLiveAgentArticleViewController(article: article)
                    navigationController?.pushViewController(articleController, animated: true)
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
            }
        default:
            decisionHandler(.allow)
        }
    }
    
}
