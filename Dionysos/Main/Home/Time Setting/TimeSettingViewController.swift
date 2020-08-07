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
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var hoursTextField: UITextField!
    @IBOutlet private weak var minutesTextField: UITextField!
    @IBOutlet private weak var secondsTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var confirmButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        hoursTextField.delegate = self
        minutesTextField.delegate = self
        secondsTextField.delegate = self
        
        hoursTextField.addTarget(self, action: #selector(formalizeText(for:)), for: .editingChanged)
        minutesTextField.addTarget(self, action: #selector(formalizeText(for:)), for: .editingChanged)
        secondsTextField.addTarget(self, action: #selector(formalizeText(for:)), for: .editingChanged)
    }
    
    @objc
    private func formalizeText(for textField: UITextField) {
        guard let text = textField.text else { return }
        let number: UInt = UInt(text) ?? 0
        textField.text = String(format: "%02d", number)
    }
    
    static func instantiate() -> TimeSettingViewController {
        let viewController: TimeSettingViewController = UIStoryboard(name: "TimeSetting", bundle: nil).instantiateInitialViewController() as! TimeSettingViewController
        return viewController
    }
}
// MARK: - UITextFieldDelegate
extension TimeSettingViewController: UITextFieldDelegate {
    enum Constant {
        static let hourMax: UInt = 24
        static let minuteMax: UInt = 60
        static let secondMax: UInt = 60
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        let isOnTyping: Bool = !string.isEmpty
        guard isOnTyping else { return true }
        guard let inputNumber = UInt(string) else { return false }
        let number: UInt = (UInt(text) ?? 0) * 10 + inputNumber
        guard "\(number)".count <= 2 else { return false }
        let limit: UInt
        switch textField {
        case hoursTextField:
            limit = Constant.hourMax
        case minutesTextField:
            limit = Constant.minuteMax
        case secondsTextField:
            limit = Constant.secondMax
        default:
            limit = 0
        }
        return number <= limit
    }
}
