//
//  ViewController.swift
//  JSCorePractise
//
//  Created by cjfire on 16/10/26.
//  Copyright © 2016年 cjfire. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class ViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var jsCore: JSContext? {
        didSet {
            
            jsCore?.exceptionHandler = { jsContext, jsValue in ()
                print("there are something wrong \(jsValue)")
            }
            
            let simplifyString: @convention(block) (String) -> String = { input in
                let mutableString = NSMutableString(string: input) as CFMutableString
                CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
                CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
                
                print(mutableString as String)
                
                return mutableString as String
            }
            
            jsCore?.setObject(unsafeBitCast(simplifyString, to: AnyObject.self), forKeyedSubscript: "simplifyString" as (NSCopying & NSObjectProtocol)!)
            jsCore?.setObject(Person.self, forKeyedSubscript: "Person" as (NSCopying & NSObjectProtocol)!)
            
            let person = Person.create("zxc", lastname: "qwe")
            jsCore?.setObject(person, forKeyedSubscript: "abc" as (NSCopying & NSObjectProtocol)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "JSCorePractise", ofType: "html")
        let url = URL(fileURLWithPath: path!)
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)//URLRequest(url: url)
        webview.loadRequest(req)
        webview.delegate = self
    }
    
    
    
    @IBAction func webview(_ sender: UIBarButtonItem) {
        webview.reload()
    }
    
    @IBAction func evaluateJS(_ sender: UIBarButtonItem) {
        let jsValue = jsCore?.evaluateScript("simplifyString('123')")
        print(jsValue)
    }
}

extension ViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        jsCore = webview.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
    }
}
