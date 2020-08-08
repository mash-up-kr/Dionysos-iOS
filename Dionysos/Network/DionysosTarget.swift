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
    case signIn(provider: String, token: String)
    case signUp(provider: String, token: String, nickname: String)
    case checkNickname(token: String, nickname: String)
}

extension DionysosTarget: TargetType {
    var path: String {
        switch self {
        case .signIn:
            return "/user/signin"
        case .signUp:
            return "/user/signup"
        case .checkNickname:
            return "/user/check/nickname"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .checkNickname:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .signIn(provider, token):
            return .requestCompositeParameters(bodyParameters: ["provider": provider, "uid": token], bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case let .signUp(provider, token, nickname):
            return .requestCompositeParameters(bodyParameters: ["provider": provider, "uid": token, "nickname": nickname], bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .checkNickname(_, let nickname):
            return .requestCompositeParameters(bodyParameters: ["nickname": nickname], bodyEncoding: JSONEncoding.default, urlParameters: [:])
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
        case .checkNickname(let token, _):
            baseHeaders["Authorization"] = token
        default:
            break
        }
        
        return baseHeaders
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}
