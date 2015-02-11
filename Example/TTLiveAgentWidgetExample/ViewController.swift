//
//  ViewController.swift
//  TTLiveAgentWidgetExample
//
//  Created by Lukas Boura on 10/02/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

import UIKit
import TTLiveAgentWidget

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToWidget(sender: AnyObject) {
        
        // Get Support widget instance
        var supportWidget = TTLiveAgentWidget.getInstance()
        
        // Config widget
        supportWidget.topics = [
            TTLiveAgentWidgetSupportTopic(key: "ios-general", title: "General issue"),
            TTLiveAgentWidgetSupportTopic(key: "ios-problem", title: "Something is not working")
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
        supportWidget.open(fromController: self, style: TTLiveAgentWidgetStyle.Push)
    }

}

