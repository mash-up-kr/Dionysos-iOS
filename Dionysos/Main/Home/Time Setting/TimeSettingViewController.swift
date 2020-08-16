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
    
    private var timeAmount: TimeAmount? {
        func getTime(from textField: UITextField) -> Int? {
            guard let timeString = textField.text else { return nil }
            return Int(timeString)
        }
        guard let hours = getTime(from: hoursTextField) else { return nil }
        guard let minutes = getTime(from: minutesTextField) else { return nil }
        guard let seconds = getTime(from: secondsTextField) else { return nil }
        return TimeAmount(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        configureTextField(hoursTextField)
        configureTextField(minutesTextField)
        configureTextField(secondsTextField)
    }
    
    private func configureTextField(_ textField: UITextField) {
        textField.delegate = self
        textField.addTarget(self, action: #selector(formalizeText(of:)), for: .editingChanged)
    }
    
    @objc
    private func formalizeText(of textField: UITextField) {
        guard let text = textField.text else { return }
        let number: UInt = UInt(text) ?? 0
        textField.text = String(format: "%02d", number)
        updateConfirmButton()
    }
    
    @IBAction private func confirmButtonDidTap(_ sender: Any) {
        let questionView: UIView = QuestionView()
        MGKAlertViewController.show(with: questionView)
    }
    
    private func updateConfirmButton() {
        let isConfirmed: Bool = validate(textFields: [hoursTextField, minutesTextField, secondsTextField])
        confirmButton.isEnabled = isConfirmed
    }
    
    private func validate(textFields: [UITextField]) -> Bool {
        // 📝 모든 시간값 입력 유무 검증
        let beReceivedAllInput: Bool = textFields
            .compactMap { $0.text }
            .filter { !$0.isEmpty }
            .count == textFields.count
        // 📝 모든 필드에 "00" 값만 존재하는 지에 대한 검증
        let isValidValue: Bool = textFields
            .contains { $0.text != "00" }
        return beReceivedAllInput && isValidValue
    }
    
    static func instantiate() -> TimeSettingViewController {
        let viewController: UIViewController? = UIStoryboard(name: "TimeSetting", bundle: nil).instantiateInitialViewController()
        return viewController as! TimeSettingViewController
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
        // 📝 on typing or on removing
        let isOnTyping: Bool = !string.isEmpty
        // 📝 on removing은 여과없이 진행
        guard isOnTyping else { return true }
        guard let range = Range(range, in: text) else { return false }
        // 📝 타이핑 결과로 입력될 텍스트
        let newText: String = text.replacingCharacters(in: range, with: string)
        let number: UInt = UInt(newText) ?? 0
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
        return number < limit
    }
}
