//
//  TTLiveAgentWidgetManager.swift
//  liveagent-ioswidget
//
//  Created by Lukas Boura on 02/02/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

import UIKit
import MessageUI

public enum TTLiveAgentWidgetStyle {
    case Push, Present
}

private let _TTLiveAgentWidget = TTLiveAgentWidget()

public class TTLiveAgentWidget: NSObject {
    
    //
    // Dependencies
    //
    var dataManager = TTLiveAgentWidgetDataManager()
    var emailComposer = TTLiveAgentWidgetEmailComposer()
    
    // MARK: - config variables
    
    //
    // Configuration
    // 
    // maxArticleCount - max count of showed articles in topic
    // topics - array of topics which filters articles
    // supportEmail - email address for support
    // supportEmailFooter - dictionary of footer data (key, value)
    // spportEmailSubject - Email subject for email composer
    //
    public var maxArticlesCount = 5
    public var topics: [SupportTopic]!
    
    public var supportEmail = ""
    public var supportEmailSubject = "iOS App - feedback/support"
    public var supportEmailFooter = [String: AnyObject]()
    
    // navigation bar appereance
    public var tintColor: UIColor!
    public var navigationBarColor: UIColor!
    public var titleColor: UIColor!
    public var statusBarStyle: UIBarStyle!
    
    //
    // Configuration - data manager
    //
    // API URL - url without slash at the end, e.g. 'http://localhost:9000'
    // Folder ID - id of live agent folder
    // API Key - live agent apikey
    public var apiURL: String {
        get {
            return self.dataManager.apiURL
        }
        set {
            self.dataManager.apiURL = newValue
        }
    }
    
    public var apiKey: String {
        get {
            return self.dataManager.apiKey
        }
        set {
            self.dataManager.apiKey = newValue
        }
    }
    
    public var folderId: String {
        get {
            return self.dataManager.folderId
        }
        set {
            self.dataManager.folderId = newValue
        }
    }
    
    
    
    // MARK: - API functions
    
    // 
    // Primary function for opening widget.
    //
    // If data manager has any articles and widget has any topics, then open main widget controller.
    // If the are no topics or articles then open email composer.
    //
    public func open(fromController controller: UIViewController, style: TTLiveAgentWidgetStyle) {
        if topics.count > 0 && dataManager.articles.count > 0 {
            showTopicsController(fromController: controller, style: style)
        } else {
            emailComposer.show(fromController: controller, topic: nil)
        }
    }
    
    //
    // Secondary function for opening widget.
    //
    // Allows to open topic questions controller by given keyword. 
    // If given keyword does not fit any topic act like primary function.
    //
    public func open(fromController controller: UIViewController, keyword: String, style: TTLiveAgentWidgetStyle) {
        if topics.count > 0 && dataManager.articles.count > 0 {
            var law = TTLiveAgentWidgetQuestionsController()
            let filteredTopics = topics.filter({$0.key == keyword})
            if filteredTopics.count > 0 {
                law.topic = filteredTopics.first
                law.tintColor = tintColor
                law.barColor = navigationBarColor
                law.titleColor = titleColor
                law.barStyle = statusBarStyle
                controller.navigationController?.pushViewController(law, animated: true)
            } else {
                showTopicsController(fromController: controller, style: style)
            }
        } else {
            emailComposer.show(fromController: controller, topic: nil)
        }
    }
    
    //
    // Open system Email composer
    //
    public func openEmailComposer(fromController controller: UIViewController, topic: SupportTopic?) {
        self.emailComposer.show(fromController: controller, topic: topic)
    }
    
    //
    //
    //
    public func updateArticles(onSuccess: (()->Void)?, onError: (()->Void)?) {
        self.dataManager.updateArticles(onSuccess, onError: onError)
    }
    
    // MARK: - private functions
    
    private func showTopicsController(fromController controller: UIViewController, style: TTLiveAgentWidgetStyle) {
        
        switch style {
            case .Push:
                
                var law = TTLiveAgentWidgetTopicsController()
                
                law.topics = topics
                law.topics = topics
                law.tintColor = tintColor
                law.barColor = navigationBarColor
                law.titleColor = titleColor
                law.barStyle = statusBarStyle
                
                controller.navigationController?.pushViewController(law, animated: true)
                
            case .Present:
                
                var law = TTLiveAgentWidgetTopicsController()
                var navCtrl = UINavigationController(rootViewController: law)
                
                law.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close button."), style: .Plain, target: law, action: "closeController")
                law.topics = topics
                law.topics = topics
                law.tintColor = tintColor
                law.barColor = navigationBarColor
                law.titleColor = titleColor
                law.barStyle = statusBarStyle
                
                controller.presentViewController(navCtrl, animated: true, completion: nil)
        }
    }
    
    public class func getInstance() -> TTLiveAgentWidget {
        return _TTLiveAgentWidget
    }
}

// MARK: - data manager

public struct SupportTopic {
    var key: String
    var title: String
    
    public init(key: String, title: String) {
        self.key = key
        self.title = title
    }
}

public struct SupportArticle {
    var title: String
    var content: String
    var keywords: String
    var order: Int
    
    public init(title: String, content: String, keywords: String, order: Int) {
        self.title = title
        self.content = content
        self.keywords = keywords
        self.order = order
    }
}

class TTLiveAgentWidgetDataManager: NSObject {
    
    let kArticleMD5KeyIdentifier = "com.tappytaps.support.widget.articlemd5"
    let kArticlesKeyIdentifier = "com.tappytaps.support.widget.articles"
    
    var userDefaults = NSUserDefaults()
    
    //
    // Configuration
    //
    // API URL - url without slash at the end, e.g. 'http://localhost:9000'
    // Folder ID - id of live agent folder
    var apiURL = ""
    var folderId: String = ""
    var apiKey: String!
    
    // Data
    var articles: [SupportArticle] {
        get {
            return self.loadArticles()
        }
    }
    
    var articlesMD5: String? {
        get {
            return userDefaults.stringForKey(kArticleMD5KeyIdentifier)
        }
        set {
            userDefaults.setObject(newValue, forKey: kArticleMD5KeyIdentifier)
        }
    }
    
    //
    // Main function for retrieving data.
    //
    // Requests server for new data. Before request, the function loads articles from user defaults (if any).
    // If 'up-to-date' property in response is true, then app has last articles. If not, the response con-
    // tains articles array. The array and its MD5 hash is then saved to user defaults.
    //
    func updateArticles(onSuccess: (()->Void)?, onError: (()->Void)?) {
        
        var url = "\(apiURL)/api/knowledgebase/articless?parent_id=\(folderId)"
        
        // if there is md5 hash add it or url
        if let hash = self.articlesMD5 {
            url += "&hash=\(hash)"
        }
        
        if apiURL == "" {
            println("API URL is missing. Can't request server.")
            return
        }
        if folderId == "" {
            println("Folder ID is missing. Can't request server.")
            return
        }
        
        if let apiKey = apiKey {
            url += "&apikey=\(apiKey)"
            println("Warning! Your API key is contained in request URL. For security reasons you should use some proxy server.")
        }
        
        var request = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {
            response, data, error in
            
            if error != nil {
                println("TTLiveAgentWidget - \(error!.localizedDescription)")
                return
            }
            
            if (response as NSHTTPURLResponse).statusCode == 200 {
                var error: NSError?
                
                
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as NSDictionary
                
                // Check if data up to date
                let upToDate = json["up-to-date"] as? Bool
                if upToDate != nil && upToDate! == true {
                    println("TTLiveAgentWidget - support articles are up to date.")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let _ = onSuccess?()
                    })
                    return
                }
                
                // Else parse articles
                let response = json["response"] as? NSDictionary
                if let res = response {
                    let articles = res["articles"] as? NSArray
                    let hash = res["hash"] as? String
                    
                    var newArticles = [SupportArticle]()
                    
                    if let articles = articles {
                        if articles.count > 0 {
                            newArticles = []
                        }
                        
                        for article in articles {
                            let title = article["title"] as String
                            let content = article["content"] as String
                            let keywords = article["keywords"] as String
                            let order = (article["rorder"] as String).toInt()
                            
                            if let order = order {
                                newArticles.append(SupportArticle(title: title, content: content, keywords: keywords, order: order))
                            } else {
                                newArticles.append(SupportArticle(title: title, content: content, keywords: keywords, order: 0))
                            }
                        }
                        
                        // Sort articles by order
                        self.saveArticles(self.articles)
                        println("TTLiveAgentWidget - new articles saved")
                        if let hash = hash {
                            self.articlesMD5 = hash
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let _ = onSuccess?()
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            let _ = onError?()
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let _ = onError?()
                    })
                }
            } else {
                println("TTLiveAgentWidget - request URL: \((response as NSHTTPURLResponse).URL)")
                println("TTLiveAgentWidget - server responded with status code \((response as NSHTTPURLResponse).statusCode)")
                dispatch_async(dispatch_get_main_queue(), {
                    let _ = onError?()
                })
            }
        })
    }
    
    func getArticlesByKeyword(keyword: String) -> [SupportArticle] {
        return articles.filter({$0.keywords.rangeOfString(keyword) != nil})
    }
    
    private func saveArticles(articles: [SupportArticle]?) {
        var dict = [[String: AnyObject]]()
        if let articles = articles {
            for article in articles {
                dict.append([
                    "title": article.title,
                    "content": article.content,
                    "keywords": article.keywords,
                    "order": article.order
                    ])
            }
            //println(dict)
            userDefaults.setObject(dict, forKey: kArticlesKeyIdentifier)
        }
    }
    
    private func loadArticles() -> [SupportArticle] {
        let dict = userDefaults.objectForKey(kArticlesKeyIdentifier) as? [[String: AnyObject]]
        if let dict = dict {
            var articles = [SupportArticle]()
            for item in dict {
                let title = item["title"] as String?
                let content = item["content"] as String?
                let keywords = item["keywords"] as String?
                let order = item["order"] as Int?
                if title != nil && content != nil && keywords != nil && order != nil{
                    articles.append(SupportArticle(title: title!, content: content!, keywords: keywords!, order: order!))
                }
            }
            return articles
        } else {
            return []
        }
        
    }
    
}

// MARK: - email composer

class TTLiveAgentWidgetEmailComposer: NSObject {
    func show(fromController controller: UIViewController, topic: SupportTopic?) {
        
        if TTLiveAgentWidget.getInstance().supportEmail == "" {
            println("TTLiveAgentWidget - can't open email composer without support email address.")
            return
        }
        
        if (MFMailComposeViewController.canSendMail()){
            
            let subject = TTLiveAgentWidget.getInstance().supportEmailSubject
            let toRecipents = NSArray(objects: TTLiveAgentWidget.getInstance().supportEmail)
            let footerDic = TTLiveAgentWidget.getInstance().supportEmailFooter
            var emailBody = "\n\n\n\n------"
            
            for (key, value) in footerDic {
                emailBody += "\n\(key): \(value)"
            }
            
            if let topic = topic {
                emailBody += "\nTopic: \(topic.title)"
            }
            
            var mailController = MFMailComposeViewController()
            mailController.setSubject(subject)
            mailController.mailComposeDelegate = self
            //mailController.setMessageBody(messageBody, isHTML: false)
            mailController.setToRecipients(toRecipents)
            mailController.setMessageBody(emailBody, isHTML: false)
            
            controller.presentViewController(mailController, animated: true, completion: nil)
        } else {
            println("TTLiveAgentWidget - can not send email")
        }
        
    }
}

extension TTLiveAgentWidgetEmailComposer: MFMailComposeViewControllerDelegate {
        func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
            switch (result.value) {
            case MFMailComposeResultCancelled.value:
                NSLog("Mail cancelled")
                break;
            case MFMailComposeResultSaved.value:
                NSLog("Mail saved")
                break;
            case MFMailComposeResultSent.value:
                NSLog("Mail sent")
                break;
            case MFMailComposeResultFailed.value:
                NSLog("Mail sent failure: %@", error.localizedDescription)
                break;
            default:
                break;
            }
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
}
