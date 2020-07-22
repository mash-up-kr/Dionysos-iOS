//
//  FacebookLogin.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import FacebookLogin
import Foundation
import Promises

struct FacebookLogin: SocialLogin {
     static func getToken() -> String? {
          if let token: AccessToken = AccessToken.current, !token.isExpired {
               return token.tokenString
          }
          return nil
     }
     
//     static func getProfileImage() -> URL? {
//          Profile.loadCurrentProfile { profile, _ in
//               let url: URL? = profile?.imageURL(forMode: .normal, size: CGSize(width: 500, height: 500))
//               logger(url)
//          }
//     }
}
