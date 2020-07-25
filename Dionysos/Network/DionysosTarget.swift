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
    case signIn
}

extension DionysosTarget: TargetType {
    var path: String {
        switch self {
        case .signIn:
            return "/user/signin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn:
            return .requestPlain
        }
    }
}

extension DionysosTarget {
    var baseURL: URL { URL(string: "http://18.217.230.58/")! }
    
    var sampleData: Data {
        Data()
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn:
            return ["Content-type": "application/json"]
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}
