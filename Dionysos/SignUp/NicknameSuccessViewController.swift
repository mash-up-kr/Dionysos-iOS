//
//  NicknameSuccessViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class NicknameSuccessViewController: UIViewController {
    @IBOutlet private weak var confirmedNicknameLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.19) {
            let nextVC = UIStoryboard.init(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "")
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func setConfirmedNickname(nickname: String) {
        confirmedNicknameLabel?.text = nickname
    }
}
