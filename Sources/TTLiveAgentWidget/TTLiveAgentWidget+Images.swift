import Foundation
import UIKit

extension TTLiveAgentWidget {
    
    public struct Images {
        public let contactUs: UIImage?
        public let question: UIImage?
        public let other: UIImage?
        public let close: UIImage?
        public let rateApp: UIImage?
        
        public init(contactUs: UIImage?, question: UIImage?, other: UIImage?, close: UIImage?, rateApp: UIImage?) {
            self.contactUs = contactUs
            self.question = question
            self.other = other
            self.close = close
            self.rateApp = rateApp
        }
        
        static var `default` = Images(
            contactUs: nil,
            question: nil,
            other: nil,
            close: nil,
            rateApp: nil
        )
    }
    
}
