//
//  MainViewController.swift
//  liveagent-ioswidget
//
//  Created by Lukas Boura on 29/01/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToWidget(sender: AnyObject) {
        
        // Get Support widget instance
        var supportWidget = TTLiveAgentWidget.getInstance()
        
        // Config wiidget
        supportWidget.topics = [
            SupportTopic(key: "ios-general", title: "General issue"),
            SupportTopic(key: "ios-problem", title: "Something is not working")
        ]
    
        // Config email
        supportWidget.supportEmail = "mysupport@mydomain.com"
        supportWidget.supportEmailSubject = "My iOS App - feedback"
        supportWidget.supportEmailFooter = [
            "ID": "123-SDF-+23",
            "OS": "iOS 8.1.3",
            "Version": "3.5.6"
        ]
        
        // Open widget
        supportWidget.open(fromController: self, style: .Push)
    }
    
    
    func createStringFromDictionary(dict: NSDictionary) -> String {
        var params: String!
        for (key, value) in dict {
            if params == nil {
                params = "\(key)=\(value)"
            } else {
                params = params + "&\(key)=\(value)"
            }
        }
        return params
    }

}
