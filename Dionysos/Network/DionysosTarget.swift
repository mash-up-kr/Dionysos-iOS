//
//  DionysosService.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/22.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Moya

enum DionysosTarget {
    case signIn(provider: String, token: String), signUp(provider: String, token: String, nickname: String)
}

extension DionysosTarget: TargetType {
    var path: String {
        switch self {
        case .signIn:
            return "/user/signin"
        case .signUp:
            return "/user/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let provider, let token):
            return .requestCompositeParameters(bodyParameters: ["provider": provider, "uid": token], bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .signUp(let provider, let token, let nickname):
            return .requestCompositeParameters(bodyParameters: ["provider": provider, "uid": token, "nickname": nickname], bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
}

extension DionysosTarget {
    var baseURL: URL { URL(string: "http://18.217.230.58")! }
    
    var sampleData: Data {
        Data()
    }
    
    var headers: [String: String]? {
        var baseHeaders: [String: String] = ["Content-type": "application/json"]
        
        switch self {
        case .signIn(let _, let token), .signUp(let _, let token, let _):
            baseHeaders["Authorization"] = token
            return baseHeaders
        default:
            return baseHeaders
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}
