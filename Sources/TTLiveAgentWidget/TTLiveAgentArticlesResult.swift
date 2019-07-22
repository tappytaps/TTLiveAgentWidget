import Foundation

struct TTLiveAgentArticlesResult: Decodable {
    let upToDate: Bool
    let response: TTLiveAgentArticlesResponse?
    
    enum CodingKeys: String, CodingKey {
        case upToDate = "up-to-date"
        case response
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        upToDate = try values.decode(Bool.self, forKey: .upToDate)
        response = try? values.decode(TTLiveAgentArticlesResponse.self, forKey: .response)
    }
}

struct TTLiveAgentArticlesResponse: Decodable {
    let articles: [TTLiveAgentArticle]
    let hash: String
}
