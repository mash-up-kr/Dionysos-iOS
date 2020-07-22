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
     
     static func getProfileImage() -> Promise<URL?> {
          Promise<URL?>(on: .main) { completion, promiseError in
               Profile.loadCurrentProfile { profile, error in
                    if let error: Error = error {
                         promiseError(error)
                    }
                    let url: URL? = profile?.imageURL(forMode: .normal, size: CGSize(width: 500, height: 500))
                    completion(url)
               }
          }
     }
}
