//
//  TTLiveAgentWidgetArticleViewController.swift
//  liveagent-ioswidget
//
//  Created by Lukas Boura on 29/01/15.
//  Copyright (c) 2015 TappyTaps s.r.o. All rights reserved.
//

import UIKit

class TTLiveAgentWidgetArticleController: UIViewController {

    // Data
    var article: TTLiveAgentWidgetSupportArticle!
    
    // Views
    var articleContentWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = NSLocalizedString("Article", comment: "Article nav bar title.")
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        let appFrame = UIScreen.mainScreen().applicationFrame
        let contentView = UIView(frame: appFrame)
        contentView.backgroundColor = UIColor.whiteColor()
        view = contentView
    }
    
    override func viewWillLayoutSubviews() {
        if articleContentWebView != nil {
            articleContentWebView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.maxY)

        }
    }
    
    func setupViews() {
        articleContentWebView = UIWebView()
        articleContentWebView.delegate = self
        articleContentWebView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.maxY)
        var htmlString = String(format: "<div style=\"padding: 0px 5px 5px 5px; font-family: %@; font-size: %i\"><h2 style=\"padding-top: 5px;font-weight: 100; margin-bottom: 0;\">%@</h2><br>%@</div>",
            "HelveticaNeue",
            16,
            article.title,
            article.content)
        articleContentWebView.loadHTMLString(htmlString, baseURL: nil)
        articleContentWebView.opaque = false
        articleContentWebView.backgroundColor = UIColor.whiteColor()
        view.addSubview(articleContentWebView)
    }

}

extension TTLiveAgentWidgetArticleController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}
