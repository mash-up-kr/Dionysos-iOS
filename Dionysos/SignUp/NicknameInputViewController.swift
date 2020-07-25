//
//  ViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Moya
import UIKit

final class NicknameInputViewController: UIViewController, KeyboardConstraintHandler {
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var nicknameReviewLabel: UILabel!
    @IBOutlet private weak var bottomConstraintOutlet: NSLayoutConstraint!
    @IBOutlet private weak var confirmButton: UIButton!
    
    @IBAction func nicknameFieldChanged(_ sender: Any) {
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
        
        apiCall()
        
//        let vc = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "NicknameSuccessViewController")
//
//        guard let successViewController = vc as? NicknameSuccessViewController else { return }
//        successViewController.modalPresentationStyle = .fullScreen
//        self.present(successViewController, animated: true, completion: nil)
//        successViewController.setConfirmedNickname(nickname: "원숭이가나무에서떨어졌다")
    }
    
    var provider: String?
    var token: String?
    
    var keyboardIsShown: Bool = false
    var baseConstraint: CGFloat = CGFloat(19)
    
    var bottomConstraint: NSLayoutConstraint? {
        bottomConstraintOutlet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardReactive()
    }
    
    private func apiCall() {
        guard let pv = provider, let tk = token, let nn = nicknameTextField.text else { return }
        DionysosProvider.callSignUp(provider: pv, token: tk, nickname: nn).then {
            logger($0)
        }.catch {
            guard let error = $0 as? Moya.MoyaError else { return }
//            if error.response?.statusCode == 401 || error.response?.statusCode == 400 {
//                guard let signUpVC = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(identifier: "NicknameInputViewController") as? NicknameInputViewController else { return }
//                signUpVC.provider = type.rawValue
//                signUpVC.token = token
//                self.present(signUpVC, animated: true, completion: nil)
//            }
        }
    }
}
