//
//  Promiseable.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/16.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Promises

enum PromiseAssociatedKey {
    static var pending = "Pending Promise"
}

protocol Promisable {
    associatedtype Value
    
    var promise: Promise<Value> { get set }
}
extension Promisable where Self: AnyObject {
    var promise: Promise<Value> {
        get {
            if let promise: Promise<Value> = objc_getAssociatedObject(self, &PromiseAssociatedKey.pending) as? Promise<Value> {
                return promise
            }
            let promise: Promise<Value> = Promise<Value>.pending()
            objc_setAssociatedObject(
                self,
                &PromiseAssociatedKey.pending,
                promise,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return promise
        }
        set {
            objc_setAssociatedObject(
                self,
                &PromiseAssociatedKey.pending,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

