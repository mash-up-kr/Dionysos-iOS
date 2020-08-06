//
//  TimeSettingViewController.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/06.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class TimeSettingViewController: UIViewController {
    // MARK: Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var confirmButtonConstraint: NSLayoutConstraint!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configure() {
        
    }
}
// MARK: - UITextFieldDelegate
extension TimeSettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        ()
    }
}
