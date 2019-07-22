import Foundation

extension TTLiveAgentWidget {
    
    public struct Strings {
        public let widgetTitle: String
        public let contactUs: String
        public let other: String
        public let rate: String
        public let privacyPolicy: String
        public let questions: String
        public let needMoreHelp: String
        
        internal init(widgetTitle: String, contactUs: String, other: String, rate: String, privacyPolicy: String, questions: String, needMoreHelp: String) {
            self.widgetTitle = widgetTitle
            self.contactUs = contactUs
            self.other = other
            self.rate = rate
            self.privacyPolicy = privacyPolicy
            self.questions = questions
            self.needMoreHelp = needMoreHelp
        }
        
        static var `default` = Strings(
            widgetTitle: "Help",
            contactUs: "Contact us",
            other: "Other",
            rate: "Rate App",
            privacyPolicy: "Privacy policy",
            questions: "Questions",
            needMoreHelp: "Need more help?"
        )
    }
    
}
