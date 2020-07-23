//
//  TargetAdapter.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Moya

struct TargetAdapter: TargetType {
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var sampleData: Data
    var task: Task
    var headers: HTTP.Headers?
}
