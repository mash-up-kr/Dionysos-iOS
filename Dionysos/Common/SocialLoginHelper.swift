//
//  SocialLoginHelper.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

protocol SocialLogin {
    static func getToken() -> String?
}

enum SocialLoginHelper {
    enum SocialLogin {
        case facebook, apple, kakao
    }
    
    static func getToken(type: SocialLogin) -> String? {
        switch type {
        case .facebook:
            return FacebookLogin.getToken()
        case .apple:
            return AppleLogin.getToken()
        case .kakao:
            return KakaoLogin.getToken()
        }
    }
}
