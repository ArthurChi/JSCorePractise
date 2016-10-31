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
        
        webView.uiDelegate = self
        
        let userScript = WKUserScript(source: "function ccc() { return 'ccc' }", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        contentController.add(self, name: "callbackHandler")
        
        webView.evaluateJavaScript("ccc()", completionHandler: { any, error in ()
            print(any)
        })
    }
}

extension WKWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "callbackHandler" {
            print("message is \(message.body)")
        }
    }
}

extension WKWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        print(message)
        
        completionHandler()
    }
}
