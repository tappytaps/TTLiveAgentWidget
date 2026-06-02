import UIKit

extension UIBarButtonItem {
    
    static func closeItem(target: Any, action: Selector) -> UIBarButtonItem {
        if let closeImage = TTLiveAgentWidget.shared.images.close {
            return UIBarButtonItem(image: closeImage, style: .plain, target: target, action: action)
        } else {
            return UIBarButtonItem(title: "Close", style: .plain, target: target, action: action)
        }
    }
    
}
