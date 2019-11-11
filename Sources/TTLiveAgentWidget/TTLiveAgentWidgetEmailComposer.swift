import Foundation
import MessageUI

class TTLiveAgentWidgetEmailComposer: NSObject {
    
    func open(from controller: UIViewController, subject: String? = nil, topicTitle: String? = nil) {
        guard let email = TTLiveAgentWidget.shared.supportEmail else {
            debugPrint("TTLiveAgentWidget - can't open email composer without support email address.")
            return
        }
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let toRecipents = [email]
        var emailBody = "\n\n\n------"
        
        if let footer = TTLiveAgentWidget.shared.supportEmailFooterProvider?() {
            for (key, value) in footer.sorted(by: { $0.key < $1.key }) {
                emailBody += "\n\(key): \(value)"
            }
        }
        
        if let topic = topicTitle {
            emailBody += "\nTopic: \(topic)"
        }
        
        let mailController = MFMailComposeViewController()
        mailController.setSubject(subject ?? TTLiveAgentWidget.shared.supportEmailSubject)
        mailController.mailComposeDelegate = self
        mailController.setToRecipients(toRecipents)
        mailController.setMessageBody(emailBody, isHTML: false)
        
        controller.present(mailController, animated: true)
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension TTLiveAgentWidgetEmailComposer: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
