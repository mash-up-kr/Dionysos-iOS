//
//  NicknameSuccessViewController.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import SDWebImage
import UIKit

class NicknameSuccessViewController: UIViewController {
    @IBOutlet private weak var successImageView: SDAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successImageView.image = SDAnimatedImage(named: "signupSuccess.gif")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.19) {
            MainTabCenter.showCurrentViewController()
        }
    }
}
