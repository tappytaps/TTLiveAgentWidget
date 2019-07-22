import Foundation
import UIKit

public struct TTLiveAgentTopic {
    let key: String?
    let image: UIImage
    let title: String
    
    public init(key: String?, image: UIImage, title: String) {
        self.key = key
        self.image = image
        self.title = title
    }
}
