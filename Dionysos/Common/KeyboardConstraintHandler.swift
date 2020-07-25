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
    func keyboardReactive()
}

extension KeyboardConstraintHandler where Self: UIViewController {
    func keyboardReactive() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            self?.addBottomConstraint(noti: notification as NSNotification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            self?.removeBottomConstraint(noti: notification as NSNotification)
        }
    }
    
    func addBottomConstraint(noti: NSNotification) {
        print("addBottom")
        guard let cgRect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        bottomConstraint?.constant = cgRect.height
    }
    
    func removeBottomConstraint(noti: NSNotification) {
        print("removeBottom")
        guard let cgRect = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        bottomConstraint?.constant = cgRect.height
    }
}
