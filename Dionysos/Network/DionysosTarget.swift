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
}

extension DionysosTarget: TargetType {
    var path: String {
        switch self {
        }
    }
    
    var method: Moya.Method {
        switch self {
        }
    }
    
    var task: Task {
        switch self {
        }
    }
}

extension DionysosTarget {
    var baseURL: URL { URL(string: "http://18.217.230.58:8080/")! }
    
    var sampleData: Data {
        Data()
    }
    
    var headers: [String: String]? {
        ["Content-type": "application/json"]
    }
    
    var validationType: ValidationType {
        .successCodes
    }
}
