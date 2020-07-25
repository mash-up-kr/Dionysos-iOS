//
//  KeyboardConstraintHandler.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

protocol KeyboardConstraintHandler {
    var bottomConstraint: NSLayoutConstraint? { get }
    var keyboardIsShown: Bool { get set }
    var baseConstraint: CGFloat { get }
    
    func keyboardReactive()
}

extension KeyboardConstraintHandler where Self: UIViewController {
    func keyboardReactive() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            guard let isShown = self?.keyboardIsShown else { return }
            if isShown {
                return
            }
            self?.addBottomConstraint(noti: notification as NSNotification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            guard let isShown = self?.keyboardIsShown else { return }
            if !isShown {
                return
            }
            self?.removeBottomConstraint(noti: notification as NSNotification)
        }
    }
    
    mutating func addBottomConstraint(noti: NSNotification) {
        guard let cgRect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        bottomConstraint?.constant = baseConstraint + cgRect.height
        keyboardIsShown = true
    }
    // struct 애플 문서보기 -> mutating
    mutating func removeBottomConstraint(noti: NSNotification) {
        bottomConstraint?.constant = baseConstraint
        keyboardIsShown = false
    }
}
