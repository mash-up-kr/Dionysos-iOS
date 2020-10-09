//
//  ProfileEditViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/09/10.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {
    @IBOutlet private weak var nicknameToEditLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameToEditLabel.placeholder = UserDefaults.standard.string(forKey: "myNickname")
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func saveButtonDidTap(_ sender: Any) {
        guard let newNickname = nicknameToEditLabel.text else { return }
        DionysosProvider.changeNickname(newNickname: newNickname).then { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
