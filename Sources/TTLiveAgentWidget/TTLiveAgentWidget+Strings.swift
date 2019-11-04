import Foundation

extension TTLiveAgentWidget {
    
    public struct Strings {
        public let widgetTitle: String
        public let contactUs: String
        public let other: String
        public let questions: String
        public let needMoreHelp: String
        public let rateApp: String
        
        public init(widgetTitle: String, contactUs: String, other: String, questions: String, needMoreHelp: String, rateApp: String) {
            self.widgetTitle = widgetTitle
            self.contactUs = contactUs
            self.other = other
            self.questions = questions
            self.needMoreHelp = needMoreHelp
            self.rateApp = rateApp
        }
        
        static var `default` = Strings(
            widgetTitle: "Help",
            contactUs: "Contact us",
            other: "Other",
            questions: "Questions",
            needMoreHelp: "Need more help?",
            rateApp: "Rate App"
        )
    }
    
}
