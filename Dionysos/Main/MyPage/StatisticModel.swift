//
//  StatisticModel.swift
//  Dionysos
//
//  Created by Jercy on 2020/10/09.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

typealias StatisticModel = [PurpleStatisticModel]

struct PurpleStatisticModel: Codable {
    let date, level: Int
}

// MARK: Convenience initializers

extension PurpleStatisticModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(PurpleStatisticModel.self, from: data) else { return nil }
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

extension Array where Element == StatisticModel.Element {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(StatisticModel.self, from: data) else { return nil }
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