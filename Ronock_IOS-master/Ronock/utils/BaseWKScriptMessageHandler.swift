//
//  BaseWKScriptMessageHandler.swift
//  Ronock
//
//  Created by Khaled Odat on 11/20/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import WebKit

class BaseWKScriptMessageHandler: WKScriptMessageHandler{
    
    func isEqual(_ object: Any?) -> Bool {
        return true
    }
    
    var hash: Int = 0
    
    var superclass: AnyClass?
    
    func `self`() -> Self {
        return self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func isProxy() -> Bool {
        return false
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        return false
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        return false
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        return true
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        return true
    }
    
    var description: String = ""
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(message.body)")
    }
}
