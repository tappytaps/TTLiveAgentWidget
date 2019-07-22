import UIKit

extension UIViewController {
    
    var isRootController: Bool {
        return navigationController?.viewControllers.first === self
    }
    
}
