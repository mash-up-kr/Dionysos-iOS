//
//  DionysosProvider.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/24.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Promises

enum DionysosProvider {
    private typealias Target = DionysosTarget
    
    //    static func callMain() -> Promise<Model> {
    //        NetworkProvider.request(Target.main, to: Model.self)
    //    }
    
    static func callSignIn(provider: String, token: String) -> Promise<SignInResponse> {
        NetworkProvider.request(Target.signIn(provider: provider, token: token), to: SignInResponse.self)
    }
    
    static func callSignUp(provider: String, token: String, nickname: String) -> Promise<SignUpResponse> {
        NetworkProvider.request(Target.signUp(provider: provider, token: token, nickname: nickname), to: SignUpResponse.self)
    }
    
    static func callCheckNickname(token: String, nickname: String) -> Promise<Void> {
        NetworkProvider.requestWithoutParsing(Target.checkNickname(token: token, nickname: nickname))
    }
}
