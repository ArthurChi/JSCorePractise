//
//  WKWebViewController.swift
//  JSCorePractise
//
//  Created by cjfire on 16/10/27.
//  Copyright © 2016年 cjfire. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {

    var contentController = WKUserContentController()
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.userContentController = self.contentController
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = view.bounds
        view.addSubview(webView)
        
        let path = Bundle.main.path(forResource: "JSCorePractise", ofType: "html")
        let url = URL(fileURLWithPath: path!)
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)//URLRequest(url: url)
        webView.load(req)
        
        let userScript = WKUserScript(source: "redHeader()", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        contentController.add(self, name: "callbackHandler")
    }
}

extension WKWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "callbackHandler" {
            print("message is \(message.body)")
        }
    }
}
