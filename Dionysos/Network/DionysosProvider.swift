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
    
    static func callSignOut(token: String) -> Promise<Void> {
        NetworkProvider.requestWithoutParsing(Target.signOut(token: token))
    }
    
    static func callCheckNickname(token: String, nickname: String) -> Promise<Void> {
        NetworkProvider.requestWithoutParsing(Target.checkNickname(token: token, nickname: nickname))
    }
    
    static func getRankingDay() -> Promise<RankingModel> {
        NetworkProvider.request(Target.rankingDay, to: RankingModel.self, direct: true)
    }
    
    static func getRankingWeek() -> Promise<RankingModel> {
        NetworkProvider.request(Target.rankingWeek, to: RankingModel.self, direct: true)
    }
    
    static func getRankingMonth() -> Promise<RankingModel> {
        NetworkProvider.request(Target.rankingMonth, to: RankingModel.self, direct: true)
    }
    
    static func getStatistic(year: Int, month: Int) -> Promise<StatisticModel> {
        NetworkProvider.request(Target.statistic(year: year, month: month), to: StatisticModel.self)
    }
    
    static func getDiary() -> Promise<DiaryModel> {
        NetworkProvider.request(Target.getDiary, to: DiaryModel.self, direct: true)
    }
    
    static func addTimeHistory(duration: Double, timeStamp: String) -> Promise<Void> {
        NetworkProvider.requestWithoutParsing(Target.addTimeHistory(duration: duration, timeStamp: timeStamp))
    }
    
    static func getTimeHistory() -> Promise<TimeHistory> {
        NetworkProvider.request(Target.getTimeHistory, to: TimeHistory.self)
    }
    
    static func changeNickname(newNickname: String) -> Promise<Void> {
        NetworkProvider.requestWithoutParsing(Target.changeNickname(newNickname: newNickname))
    }
}
