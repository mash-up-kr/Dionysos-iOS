//
//  ViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class NicknameInputViewController: UIViewController, KeyboardConstraintHandler {
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var nicknameReviewLabel: UILabel!
    @IBOutlet private weak var bottomConstraintOutlet: NSLayoutConstraint!
    @IBOutlet private weak var confirmButton: UIButton!
    
    @IBAction func nicknameFieldChanged(_ sender: Any) {
        
        // print(nicknameTextField.text)
        // apicall
        if true {
            confirmButton.isSelected = true
            // 응답을 화면에 보여줌
            nicknameReviewLabel.text = "진짜 멋지다!"
            nicknameReviewLabel.textColor = UIColor(named: "azure")
            confirmButton.isEnabled = true
        } else {
            confirmButton.isSelected = false
            confirmButton.isEnabled = false
            nicknameReviewLabel.text = "음..........."
            nicknameReviewLabel.textColor = UIColor(named: "coralPink")
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        // 닉네임 넣어서 회원가입 apiCall
        
        let vc = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "NicknameSuccessViewController")
        
        guard let successViewController = vc as? NicknameSuccessViewController else { return }
        successViewController.modalPresentationStyle = .fullScreen
        self.present(successViewController, animated: true, completion: nil)
        successViewController.setConfirmedNickname(nickname: "원숭이가나무에서떨어졌다")
    }
    
    var keyboardIsShown: Bool = false
    var baseConstraint: CGFloat = CGFloat(19)
    
    var bottomConstraint: NSLayoutConstraint? {
        bottomConstraintOutlet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardReactive()
    }
}
