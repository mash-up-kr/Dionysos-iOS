//
//  SocialLoginHelper.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

enum SocialLoginHelper {
    enum SocialLoginType {
        case facebook, apple, kakao, guest
    }
    
    static func apiCall(type: SocialLoginType, UID: String?) {
//        NetworkProvider.request(<#T##target: TargetType##TargetType#>, to: <#T##Decodable.Protocol#>)
        
        if true {
            let token: String = ""
            UserDefaults.standard.set(token, forKey: "myToken")
            UIApplication.shared.currentWindow?.rootViewController = MainTabCenter.default.getCurrentViewController()
        }
    }
}
