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
    
    @IBAction private func nicknameFieldChanged(_ sender: UITextField) {
        checkNicknameApiCall(nickname: sender.text)
    }
    
    @IBAction private func confirmButtonClicked(_ sender: Any) {
        signUpApiCall()
    }
    
    lazy var errorView: NetworkErrorView = {
        let errorView: NetworkErrorView = NetworkErrorView()
        errorView.setData(mainView: view, delegate: self)
        return errorView
    }()
    
    private var provider: String?
    private var token: String?
    
    var keyboardIsShown: Bool = false
    var baseConstraint: CGFloat = 19
    
    var bottomConstraint: NSLayoutConstraint? {
        bottomConstraintOutlet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardReactive()
    }

    func setData(provider: String, token: String) {
        self.provider = provider
        self.token = token
    }
    
    private func checkNicknameApiCall(nickname: String?) {
        guard let token = token, let nickname = nickname else { return }
        
        DionysosProvider.callCheckNickname(token: token, nickname: nickname).then { [weak self] in
            guard let self = self else { return }
            self.confirmButton.isSelected = true
            self.nicknameReviewLabel.text = "진짜 멋지다!"
            self.nicknameReviewLabel.textColor = UIColor(named: "azure")
            self.confirmButton.isEnabled = true
        }.catch { [weak self] in
            guard let self = self, let error = $0 as? Moya.MoyaError else { return }
            logger(error)
            self.confirmButton.isSelected = false
            self.confirmButton.isEnabled = false
            self.nicknameReviewLabel.text = "음..........."
            self.nicknameReviewLabel.textColor = UIColor(named: "coralPink")
        }
    }
    
    private func signUpApiCall() {
        guard let provider = provider, let token = token, let nickName = nicknameTextField.text else { return }
        DionysosProvider.callSignUp(provider: provider, token: token, nickname: nickName).then { [weak self] in
            guard let successViewController = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "NicknameSuccessViewController") as? NicknameSuccessViewController else { return }
            successViewController.modalPresentationStyle = .fullScreen
            UserDefaults.standard.set($0.jwt, forKey: "myToken")
            self?.present(successViewController, animated: true, completion: nil)
        }.catch { [weak self] in
            guard let error = $0 as? Moya.MoyaError else { return }
            self?.errorView.isHidden = false
            logger(error)
        }
    }
}

extension NicknameInputViewController: NetworkErrorRetryDelegate {
    func callRetry() {
        checkNicknameApiCall(nickname: nicknameTextField.text)
    }
}
