//
//  Person.swift
//  JSCorePractise
//
//  Created by cjfire on 16/10/27.
//  Copyright © 2016年 cjfire. All rights reserved.
//

import UIKit
import JavaScriptCore

typealias Block = () -> Void

@objc protocol PersonJSExports: JSExport {
    var firstName: String {set get}
    var lastName: String {set get}
    var birthYear: NSNumber {set get}
    
    static func create(_ firstname: String, lastname: String) -> Person
    func fullName() -> String
    func setCallback(callback: JSValue)
}

class Person: NSObject, PersonJSExports {
    
    internal static func create(_ firstname: String, lastname: String) -> Person {
        let person = Person()
        person.firstName = firstname
        person.lastName = lastname
        
        return person
    }

    internal func fullName() -> String {
        return "\(firstName)~\(lastName)"
    }

    internal var birthYear: NSNumber = 0.0

    internal var lastName: String = ""

    internal var firstName: String = ""
    
    internal func setCallback(callback: JSValue) {
        
        let str = callback.toString() ?? ""
        
        Thread.sleep(forTimeInterval: 2)
        
        print(str)
        
        let _ = callback.context.evaluateScript("(\(str)('this is message'))")
    }
}
