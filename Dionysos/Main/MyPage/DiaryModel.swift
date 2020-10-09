//
//  DiaryModel.swift
//  Dionysos
//
//  Created by Jercy on 2020/10/09.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

typealias DiaryModel = [PurpleDiaryModel]

struct PurpleDiaryModel: Codable {
    let content: String
    let id: Int
    let imageURL, uid: String

    enum CodingKeys: String, CodingKey {
        case content, id
        case imageURL = "imageUrl"
        case uid
    }
}

// MARK: Convenience initializers

extension PurpleDiaryModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(PurpleDiaryModel.self, from: data) else { return nil }
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

extension Array where Element == DiaryModel.Element {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(DiaryModel.self, from: data) else { return nil }
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
