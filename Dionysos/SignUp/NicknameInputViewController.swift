//
//  ViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class NicknameInputViewController: UIViewController, KeyboardConstraintHandler {
    @IBOutlet private weak var confirmView: UIView!
    @IBOutlet private weak var bottomConstraintOutlet: NSLayoutConstraint?
    
    var bottomConstraint: NSLayoutConstraint? {
        bottomConstraintOutlet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardReactive()
    }
}
