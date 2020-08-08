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
    
    @IBAction private func nicknameFieldChanged(_ sender: Any) {
        print(nicknameTextField.text)
        //checkNicknameApiCall(nickname: nicknameTextField.text!)
    }
    
    @IBAction private func confirmButtonClicked(_ sender: Any) {
        signUpApiCall()
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

    private func checkNicknameApiCall(nickname: String) {
        guard let token = self.token, let nickname = nicknameTextField.text else { return }
        
        DionysosProvider.callCheckNickname(token: token, nickname: nickname).then {
            self.confirmButton.isSelected = true
            // 응답을 화면에 보여줌
            self.nicknameReviewLabel.text = "진짜 멋지다!"
            self.nicknameReviewLabel.textColor = UIColor(named: "azure")
            self.confirmButton.isEnabled = true
            
            guard let successViewController = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "NicknameSuccessViewController") as? NicknameSuccessViewController else { return }
            successViewController.modalPresentationStyle = .fullScreen
            print($0)
            self.present(successViewController, animated: true, completion: nil)
        }.catch {
            guard let error = $0 as? Moya.MoyaError else { return }
            print(error)
            self.confirmButton.isSelected = false
            self.confirmButton.isEnabled = false
            self.nicknameReviewLabel.text = "음..........."
            self.nicknameReviewLabel.textColor = UIColor(named: "coralPink")
        }
    }
    
    private func signUpApiCall() {
        guard let prov = provider, let tkn = token, let name = nicknameTextField.text else { return }
        DionysosProvider.callSignUp(provider: prov, token: tkn, nickname: name).then {
            guard let successViewController = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "NicknameSuccessViewController") as? NicknameSuccessViewController else { return }
            successViewController.modalPresentationStyle = .fullScreen
            UserDefaults.standard.set($0.jwt, forKey: "myToken")
            self.present(successViewController, animated: true, completion: nil)
        }.catch {
            guard let error = $0 as? Moya.MoyaError else { return }
        }
    }
}
