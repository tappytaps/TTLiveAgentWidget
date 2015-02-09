//
//  TTLiveAgentWidgetQuestionsViewController.swift
//  liveagent-ioswidget
//
//  Created by Lukas Boura on 02/02/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

import UIKit
import MessageUI

class TTLiveAgentWidgetQuestionsController: UITableViewController {

    var topic: SupportTopic!
    private var onceReload: dispatch_once_t = 0

    private let kLAArticleCellIdentifier = "TTLiveAgentWidgetArticleCell"
    private let kLAIconCellIdentifier = "TTLiveAgentWidgetIconCell"
    
    private var supportWidget = TTLiveAgentWidget.getInstance()
    
    var contentOffset: CGFloat!
    
    var articles: [SupportArticle]!
    var tintColor: UIColor!
    var barColor: UIColor!
    var titleColor: UIColor!
    var barStyle: UIBarStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Contact Us", comment: "Contact Us nav bar title.")
        let backButton = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back button."), style: .Plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
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
        
        articles = supportWidget.dataManager.getArticlesByKeyword(topic.key)
        articles.sort({$0.order < $1.order})
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableView = tableView {
            if contentOffset != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: self.contentOffset), animated: false)
                })
            }
            dispatch_once(&onceReload, {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override func loadView() {
        if !isViewLoaded() {
            let appFrame = UIScreen.mainScreen().applicationFrame
            let contentView = UIView(frame: appFrame)
            contentView.backgroundColor = UIColor.whiteColor()
            self.view = contentView
            self.view.autoresizesSubviews = true
        }
    }
    
    func setupViews() {
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delaysContentTouches = false
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kLAArticleCellIdentifier)
        self.tableView.registerClass(IconTableViewCell.self, forCellReuseIdentifier: kLAIconCellIdentifier)
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if let tableView = self.tableView {
            tableView.reloadData()
        }
    }

}

//
// UITableView DataSource
//
extension TTLiveAgentWidgetQuestionsController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let articles = articles {
                return articles.count > supportWidget.maxArticlesCount ? supportWidget.maxArticlesCount : articles.count
            }
            return 0
        } else {
            return 1
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            if articles.count == 0 {
                return nil
            } else {
                return NSLocalizedString("Popular questions", comment: "Popular questions table view section header title.")
            }
        case 1:
            return  NSLocalizedString("Contact us", comment: "Contact us table view section header title.")
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if articles == nil || articles.count == 0 {
                return 0.01
            }
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier(kLAArticleCellIdentifier) as UITableViewCell
            var topic = articles[indexPath.row]
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = topic.title
            cell.textLabel?.font = UIFont.systemFontOfSize(16)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            cell.autoresizesSubviews = true
            cell.autoresizingMask = UIViewAutoresizing.FlexibleHeight
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(kLAIconCellIdentifier) as IconTableViewCell
            cell.accessoryType = .DisclosureIndicator
            cell.iconView.image = UIImage(named: "Envelope.png")
            cell.titleLabel.text = NSLocalizedString("Send email to support", comment: "Send support email table view row.")
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

//
// UITableView Delegate
//
extension TTLiveAgentWidgetQuestionsController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            let contentOffset = tableView.contentOffset.y
            let lawa = TTLiveAgentWidgetArticleController()
            lawa.article = articles[indexPath.row]
            self.navigationController?.pushViewController(lawa, animated: true)
        } else if indexPath.section == 1 {
            supportWidget.emailComposer.show(fromController: self, topic: topic)
        }
    }
}

private class IconTableViewCell: UITableViewCell {
    
    var iconView: UIImageView!
    var titleLabel: UILabel!
    
    override init() {
        super.init()
        setupViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        iconView = UIImageView()
        iconView.frame = CGRect(x: 14, y: 12, width: self.contentView.frame.height - 10, height: self.contentView.frame.height - 24)
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(iconView)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: iconView.frame.maxX + 8, y: 0, width: self.contentView.frame.width - (iconView.frame.maxX + 8), height: self.contentView.frame.height)
        titleLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(titleLabel)
        
        self.accessoryType = .DisclosureIndicator
    }
}



