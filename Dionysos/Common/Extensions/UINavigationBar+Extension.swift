//
//  UINavigationBar+Extension.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

private var flatAssociatedObjectKey: UInt8 = 0

@IBDesignable
extension UINavigationBar {
    @IBInspectable var flat: Bool {
        get {
            guard let obj = objc_getAssociatedObject(self, &flatAssociatedObjectKey) as? NSNumber else {
                return false
            }
            return obj.boolValue
        }
        
        set {
            if newValue {
                let void: UIImage = UIImage()
                setBackgroundImage(void, for: .any, barMetrics: .default)
                shadowImage = void
            } else {
                setBackgroundImage(nil, for: .any, barMetrics: .default)
                shadowImage = nil
            }
            objc_setAssociatedObject(self, &flatAssociatedObjectKey, NSNumber(value: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
