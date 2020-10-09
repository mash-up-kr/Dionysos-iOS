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
    case signOut(token: String)
    case rankingDay
    case rankingWeek
    case rankingMonth
    case statistic(year: Int, month: Int)
    case addTimeHistory(duration: Double, timeStamp: String)
    case getTimeHistory
    case getDiary
    case changeNickname(newNickname: String)
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
        case .signOut:
            return "/user/signout"
        case .rankingDay:
            return "/ranking/day"
        case .rankingWeek:
            return "/ranking/week"
        case .rankingMonth:
            return "/ranking/month"
        case .statistic:
            return "/statistic"
        case .getDiary:
            return "/diary"
        case .addTimeHistory,
            .getTimeHistory:
            return "/time-history"
        case .changeNickname:
            return "/user/my"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .rankingDay, .rankingWeek, .rankingMonth, .statistic, .getDiary, .getTimeHistory:
            return .get
        case .signIn, .signUp, .checkNickname, .addTimeHistory:
            return .post
        case .changeNickname:
            return .put
        case .signOut:
            return .delete
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
        case .signOut(_):
            return .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: [:]) // body 넣을 필요 없는데??
        case .rankingDay, .rankingWeek, .rankingMonth, .getDiary, .getTimeHistory:
            return .requestPlain
        case .statistic(let year, let month):
            return .requestParameters(parameters: ["year": year, "month": month], encoding: JSONEncoding.default)
        case .addTimeHistory(let duration, let timeStamp):
            return .requestParameters(parameters: ["duration": duration, "historyDay": timeStamp], encoding: JSONEncoding.default)
        case .changeNickname(let newNickname):
            return .requestParameters(parameters: ["nickname": newNickname], encoding: JSONEncoding.default)
        }
    }
}

extension DionysosTarget {
    var baseURL: URL { URL(string: "http://13.125.51.10:8080")! }
    
    var sampleData: Data {
        Data()
    }
    
    var headers: [String: String]? {
        var baseHeaders: [String: String] = ["Content-type": "application/json"]
        
        if let token = UserDefaults.standard.string(forKey: "myToken") {
            baseHeaders["Authorization"] = token
        }
        
        return baseHeaders
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}
