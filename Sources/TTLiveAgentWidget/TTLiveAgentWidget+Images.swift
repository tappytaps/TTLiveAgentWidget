import Foundation
import UIKit

extension TTLiveAgentWidget {
    
    public struct Images {
        public let contactUs: UIImage?
        public let question: UIImage?
        public let other: UIImage?
        public let privacyPolicy: UIImage?
        public let rate: UIImage?
        public let close: UIImage?
        
        public init(contactUs: UIImage?, question: UIImage?, other: UIImage?, privacyPolicy: UIImage?, rate: UIImage?, close: UIImage?) {
            self.contactUs = contactUs
            self.question = question
            self.other = other
            self.privacyPolicy = privacyPolicy
            self.rate = rate
            self.close = close
        }
        
        static var `default` = Images(
            contactUs: nil,
            question: nil,
            other: nil,
            privacyPolicy: nil,
            rate: nil,
            close: nil
        )
    }
    
}
