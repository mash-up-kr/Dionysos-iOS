//
//  KakaoLogin.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import KakaoOpenSDK
import Promises

enum KakaoAuth: SocialLogin {

    static func login() -> Promise<Void> {
        Promise<Void> { fulfill, reject in
            guard let session = KOSession.shared() else { throw Error.missingSession }
            if session.isOpen() {
                session.close()
            }
            session.open { error in
                if let error = error {
                    reject(error)
                }
                fulfill(Void())
            }
        }
    }
    
    static func logout() -> Promise<Bool> {
        Promise<Bool> { fulfill, reject in
            guard let session = KOSession.shared() else { throw Error.missingSession }
            session.logoutAndClose { isSuccess, error in
                if let error = error {
                    reject(error)
                }
                fulfill(isSuccess)
            }
        }
    }
    
    static func getToken() -> String? {
        guard let session = KOSession.shared() else { return nil }
        return session.token?.accessToken
    }
    
    enum Error: Swift.Error {
        case missingSession
    }
}
