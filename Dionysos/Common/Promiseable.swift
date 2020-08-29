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

protocol Promiseable {
    associatedtype Output
    
    var pending: Promise<Output> { get }
}
extension Promiseable {
    var pending: Promise<Output> {
        get { objc_getAssociatedObject(self, PromiseAssociatedKey.pending) as! Promise<Output> }
        set { objc_setAssociatedObject(self, PromiseAssociatedKey.pending, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}
