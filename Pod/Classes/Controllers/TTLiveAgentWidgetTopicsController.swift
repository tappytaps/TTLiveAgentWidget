//
//  ViewController.swift
//  liveagent-ioswidget
//
//  Created by Lukas Boura on 28/01/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

import UIKit
import Foundation

class TTLiveAgentWidgetTopicsController: UITableViewController {
    
    // Configuration
    var topics: [TTLiveAgentWidgetSupportTopic]!
    var tintColor: UIColor!
    var barColor: UIColor!
    var titleColor: UIColor!
    var barStyle: UIBarStyle!
    
    // Views
    let kLAArticleCellIdentifier = "TTLiveAgentWidgetArticleCell"
    
    var pointNow: CGPoint!
    var contentOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Contact Us", comment: "Contact Us nav bar title.")

        if tintColor != nil {
            self.navigationController?.navigationBar.tintColor = tintColor
        }
        if barColor != nil {
            self.navigationController?.navigationBar.barTintColor = barColor
            self.navigationController?.navigationBar.translucent = false
        }
        if titleColor != nil {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: titleColor
            ]
        }
        if barStyle != nil {
            self.navigationController?.navigationBar.barStyle = barStyle
        }
        
        setupViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        if !isViewLoaded() {
            let appFrame = UIScreen.mainScreen().applicationFrame
            let contentView = UIView(frame: appFrame)
            contentView.backgroundColor = UIColor.whiteColor()
            self.view = contentView
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        if let tableView = tableView {
            if contentOffset != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: self.contentOffset), animated: false)
                })
            }
        }

    }
    
    func closeController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupViews() {
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delaysContentTouches = false
        //self.tableView.estimatedRowHeight = 300
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kLAArticleCellIdentifier)
    }
    
}

//
// UITableView DataSource
//
extension TTLiveAgentWidgetTopicsController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let topics = topics {
            return topics.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
            case 0:
                return NSLocalizedString("Choose topic of your message", comment: "Choose topic table view section title.")
            default:
                return ""
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return NSLocalizedString("We answer to every message you sent to us. Correct topic helps us to get back to you faster.", comment: "Choose topic table view footer message.")
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(kLAArticleCellIdentifier) as UITableViewCell
            var topic = topics[indexPath.row]
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = topic.title
            cell.textLabel?.font = UIFont.systemFontOfSize(16)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}

//
// UITableView Delegate
//
extension TTLiveAgentWidgetTopicsController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let lawq = TTLiveAgentWidgetQuestionsController()
        lawq.topic = topics[indexPath.row]
        self.navigationController?.pushViewController(lawq, animated: true)
        
    }
}
