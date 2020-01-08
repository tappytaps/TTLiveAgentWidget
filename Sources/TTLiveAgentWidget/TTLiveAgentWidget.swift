import Foundation
import UIKit

public class TTLiveAgentWidget {
    
    public enum TransitionStyle {
        case push, present
    }
    
    /// Shared widget instance
    public static let shared = TTLiveAgentWidget()
    
    // MARK: Dependencies
    
    private let dataManager = TTLiveAgentWidgetDataManager.shared
    private let mailComposer = TTLiveAgentWidgetEmailComposer()
    
    // MARK: Public API
    
    public var strings: Strings = .default
    public var images: Images = .default
    
    public var topics: [TTLiveAgentTopic] = []
    
    public var supportEmail: String?
    public var supportEmailSubject = "iOS App - feedback/support"
    public var supportEmailFooterProvider: (() -> [String: String])?
        
    /// Your app id. Used for rate app action.
    public var appId: String?
    
    /// Live agent API url
    public var apiUrl: URL?
    /// Live agent API key
    public var apiKey: String?
    /// Live agent folder
    public var apiFolderId: Int?
    public var apiTreePath: String?
    /// Articles limit for topic
    public var apiLimitArticles: Int?
    
    public var baseUrl: URL? { dataManager.baseUrl }
    
    /// Update articles.
    ///
    /// - Parameter completion: Completion handler.
    public func updateArticles(completion: ((Result<Void, Error>) -> Void)?) {
        dataManager.updateArticles { result in
            switch result {
            case .success:
                completion?(.success(()))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    /// Opens widget.
    ///
    /// - Parameter controller: Controller to open widget from.
    /// - Parameter topicKey: Topic key. If nil widget shows screen with all topics.
    /// - Parameter transition: Transition style (.present or .push).
    public func open(from controller: UIViewController, topicKey: String? = nil, transition: TransitionStyle = .present) {
        var topic: TTLiveAgentTopic?
        if let topicKey = topicKey {
            topic = topics.first { $0.key == topicKey }
        }
        if let topic = topic {
            open(topic, from: controller, transition: transition)
        } else {
            openTopics(from: controller, transition: transition)
        }
    }
    
    /// Opens email composer
    ///
    /// - Parameter controller: Controller to open mail composer from.
    /// - Parameter topicTitle: Topic title placed at the bottom of email body.
    public func openMailComposer(from controller: UIViewController, subject: String? = nil, topicTitle: String? = nil) {
        mailComposer.open(from: controller, subject: subject, topicTitle: topicTitle)
    }
    
    /// Opens App Store page for given appId.
    public func openRateApp() {
        guard let rateAppUrl = rateAppUrl else {
            return
        }
        UIApplication.shared.open(rateAppUrl)
    }
    
}

// MARK: - Private API

private extension TTLiveAgentWidget {
    
    func openTopics(from controller: UIViewController, transition: TransitionStyle) {
        let topicsController = TTLiveAgentTopicsViewController(topics: topics)
        open(topicsController, from: controller, transition: transition)
    }
    
    func open(_ topic: TTLiveAgentTopic, from controller: UIViewController, transition: TransitionStyle) {
        let topicController = TTLiveAgentTopicViewController(topic: topic)
        open(topicController, from: controller, transition: transition)
    }
    
    func open(_ controller: UIViewController, from presentingController: UIViewController, transition: TransitionStyle) {
        guard !topics.isEmpty else {
            openMailComposer(from: controller)
            return
        }
        switch transition {
        case .present:
            let navigationController = UINavigationController(rootViewController: controller)
            if #available(iOS 13.0, *) {
                navigationController.navigationBar.standardAppearance.configureWithOpaqueBackground()
                navigationController.navigationBar.standardAppearance.shadowColor = .systemFill
            } else {
                navigationController.navigationBar.isOpaque = true
                navigationController.navigationBar.isTranslucent = false
                navigationController.navigationBar.backgroundColor = .white
            }
            if #available(iOS 11.0, *) {
                if UIScreen.main.bounds.width <= 320 {
                    navigationController.navigationBar.prefersLargeTitles = false
                } else {
                    navigationController.navigationBar.prefersLargeTitles = true
                }
            }
            navigationController.modalPresentationStyle = .formSheet
            presentingController.present(navigationController, animated: true)
        case .push:
            presentingController.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    var rateAppUrl: URL? {
        guard let appId = appId else {
            return nil
        }
        return URL(string: "https://itunes.apple.com/us/app/id\(appId)?action=write-review")
    }
    
}
