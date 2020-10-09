//
//  RankingModel.swift
//  Dionysos
//
//  Created by Jercy on 2020/10/09.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

typealias RankingModel = [EachRankingModel]

struct EachRankingModel: Codable {
    let userID: Int
    let nickname: String
    let duration: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, duration
    }
}

// MARK: Convenience initializers

extension EachRankingModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(EachRankingModel.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Array where Element == RankingModel.Element {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(RankingModel.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
