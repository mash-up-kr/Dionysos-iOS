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

enum KakaoAuth {
    static func login() -> Promise<Void> {
        Promise<Void> { fulfill, reject in
            guard let session = KOSession.shared() else { throw Error.missingSession }
            if session.isOpen() {
                session.close()
            }
            session.open { error in
                if let error: Swift.Error = error {
                    reject(error)
                }
                fulfill(Void())
            }
        }
    }
    
    @discardableResult
    static func logout() -> Promise<Bool> {
        Promise<Bool> { fulfill, reject in
            guard let session = KOSession.shared() else { throw Error.missingSession }
            session.logoutAndClose { isSuccess, error in
                if let error: Swift.Error = error {
                    reject(error)
                }
                fulfill(isSuccess)
            }
        }
    }
    
    static func getUID() -> Promise<String?> {
        Promise<String?> { fulfill, reject in
            guard let session = KOSession.shared() else { throw Error.missingSession }
            guard session.isOpen() else { throw Error.sessionNotYetOpen }
            KOSessionTask.userMeTask { error, user in
                if let error: Swift.Error = error {
                  reject(error)
                }
                fulfill(user?.id)
            }
        }
    }
    
    enum Error: Swift.Error {
        case missingSession
        case sessionNotYetOpen
    }
}
