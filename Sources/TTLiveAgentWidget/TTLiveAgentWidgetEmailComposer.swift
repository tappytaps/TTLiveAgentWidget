import Foundation
import MessageUI

class TTLiveAgentWidgetEmailComposer: NSObject {
    
    func open(from controller: UIViewController, subject: String? = nil, topicTitle: String? = nil) {
        guard let email = TTLiveAgentWidget.shared.supportEmail else {
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
        
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.setSubject(subject ?? TTLiveAgentWidget.shared.supportEmailSubject)
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(toRecipents)
            mailController.setMessageBody(emailBody, isHTML: false)
            
            controller.present(mailController, animated: true)
        } else {
            // On Mac Catalyst or if the system Mail app is not installed the MFMailComposeViewController.canSendMail() returns false.
            // So we open the mail composer via mailto url.
            let mailtoURLString = String(format: "mailto:%@?subject=%@&body=%@", email, subject ?? TTLiveAgentWidget.shared.supportEmailSubject, emailBody)
            if let mailtoURL = URL(string: mailtoURLString), UIApplication.shared.canOpenURL(mailtoURL) {
                UIApplication.shared.open(mailtoURL)
            }
        }
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension TTLiveAgentWidgetEmailComposer: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
