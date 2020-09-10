//
//  ProfileEditViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/09/10.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
