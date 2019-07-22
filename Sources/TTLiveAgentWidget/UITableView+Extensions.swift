import UIKit

extension UITableView {
    
    func configureWidgetStyle() {
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        separatorStyle = .none
    }
    
}
