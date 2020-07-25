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

enum KakaoLogin: SocialLogin {
    
    static func refreshSession() -> Promise<Void> {
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
    
    static func getToken() -> String? {
        guard let session = KOSession.shared() else { return nil }
        return session.token?.accessToken
    }
    
    enum Error: Swift.Error {
        case missingSession
    }
}
