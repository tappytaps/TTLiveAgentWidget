import Foundation

class TTLiveAgentWidgetDataManager {
    
    private let articlesMD5UserDefaultsKey = "com.tappytaps.support.widget.articlemd5"
    private let baseUrlUserDefaultsKey = "com.tappytaps.support.widget.baseurl"
    
    enum UpdateArticlesError: Error {
        case missingConfiguration
        case requestFailed
        case jsonDecodeFailed
    }
    
    static let shared = TTLiveAgentWidgetDataManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    func updateArticles(completion: @escaping (Result<Void, UpdateArticlesError>) -> Void) {
        guard let apiUrl = TTLiveAgentWidget.shared.apiUrl else {
            completion(.failure(.missingConfiguration))
            return
        }
        guard TTLiveAgentWidget.shared.apiFolderId != nil || TTLiveAgentWidget.shared.apiTreePath != nil else {
            completion(.failure(.missingConfiguration))
            return
        }
        
        var urlComponents = URLComponents(
            url: apiUrl.appendingPathComponent("api/knowledgebase/articles"),
            resolvingAgainstBaseURL: false
        )
        
        if let apiFolderId = TTLiveAgentWidget.shared.apiFolderId {
            urlComponents?.queryItems = [
                URLQueryItem(name: "parent_id", value: "\(apiFolderId)")
            ]
        }
        
        if let apiTreePath = TTLiveAgentWidget.shared.apiTreePath {
            urlComponents?.queryItems = [
                URLQueryItem(name: "tree_path", value: "\(apiTreePath)")
            ]
        }
                
        if let hash = articlesMD5 {
            if hasArticles {
                urlComponents?.queryItems?.append(URLQueryItem(name: "hash", value: hash))
            }
        }
        
        if let apiKey = TTLiveAgentWidget.shared.apiKey {
            urlComponents?.queryItems?.append(URLQueryItem(name: "apikey", value: apiKey))
            debugPrint("TTLiveAgentWidget - Warning! Your API key is contained in request URL. For security reasons you should use some proxy server.")
        }
        
        if let apiLimitArticles = TTLiveAgentWidget.shared.apiLimitArticles {
            urlComponents?.queryItems?.append(URLQueryItem(name: "limit", value: "\(apiLimitArticles)"))
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.requestFailed))
            return
        }
        
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringCacheData,
            timeoutInterval: 10
        )
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.requestFailed))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode(TTLiveAgentArticlesResult.self, from: data)
                debugPrint("✅", result)
                if let articlesResponse = result.response {
                    self.saveArticles(from: articlesResponse)
                }
                self.baseUrl = result.baseUrl
                completion(.success(()))
            } catch let error {
                debugPrint("🔴", error)
                completion(.failure(.jsonDecodeFailed))
            }
        }.resume()
    }
    
    func loadArticles() -> [TTLiveAgentArticle] {
        do {
            let data = try Data(contentsOf: articlesPlistUrl)
            let articles = try PropertyListDecoder().decode([TTLiveAgentArticle].self, from: data)
            return articles
        } catch _ {
            return []
        }
    }
    
    func loadArticles(for topic: TTLiveAgentTopic) -> [TTLiveAgentArticle] {
        guard let keyword = topic.key else {
            return []
        }
        return loadArticles()
            .filter { $0.keywords.contains(keyword) }
    }
    
    private var articlesMD5: String? {
        get {
            userDefaults.string(forKey: articlesMD5UserDefaultsKey)
        }
        set {
            userDefaults.set(newValue, forKey: articlesMD5UserDefaultsKey)
        }
    }
    
    private(set) var baseUrl: URL? {
        get {
            userDefaults.url(forKey: baseUrlUserDefaultsKey)
        }
        set {
            userDefaults.set(newValue, forKey: baseUrlUserDefaultsKey)
        }
    }
    
    private var hasArticles: Bool {
        let data = try? Data(contentsOf: articlesPlistUrl)
        return data != nil
    }
    
    private var articlesPlistUrl: URL {
        // get App's /Library/Caches directory
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true).first!
        // create path to plist file
        return URL(fileURLWithPath: cachesPath.appending("/TTLiveAgentArticles.plist"))
    }
    
    private func saveArticles(from response: TTLiveAgentArticlesResponse) {
        let articles = response.articles
        let hash = response.hash
        
        do {
            let data = try PropertyListEncoder().encode(articles)
            try data.write(to: articlesPlistUrl)
            articlesMD5 = hash
        } catch let error {
            debugPrint(error)
        }
    }
    
}
