//
//  FacebookAuth.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import FacebookLogin
import Foundation
import Promises

enum FacebookAuth {
    static func login() -> Promise<Bool> {
        Promise<Bool> { fulfill, reject in
            LoginManager.shared.logIn(permissions: [.publicProfile]) { result in
                switch result {
                case .success:
                    fulfill(true)
                case .cancelled:
                    fulfill(false)
                case .failed(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func getUID() -> String? {
        AccessToken.current?.userID
    }
    
    static func logout() {
        LoginManager.shared.logOut()
    }
}

extension LoginManager {
    static let shared: LoginManager = LoginManager()
}
