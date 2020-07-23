//
//  EndPointType.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Moya

protocol EndPointType {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTP.Method { get }
    var sampleData: Data { get }
    var task: Task { get }
    var headers: HTTP.Headers? { get }
}
extension EndPointType {
    func toTarget() -> TargetAdapter {
        TargetAdapter(
            baseURL: self.baseURL,
            path: self.path,
            method: self.method,
            sampleData: self.sampleData,
            task: self.task,
            headers: self.headers
        )
    }
}
