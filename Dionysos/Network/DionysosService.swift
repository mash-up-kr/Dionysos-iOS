//
//  DionysosService.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/22.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Moya

enum DionysosService {
}

extension DionysosService: TargetType {
     var baseURL: URL { URL(string: "http://13.124.57.224")! }

     var path: String {
          switch self {
          }
     }

     var method: Moya.Method {
          switch self {
          }
     }

     var sampleData: Data {
          Data()
     }

     var task: Task {
          switch self {
          }
     }

     var headers: [String: String]? {
          ["Content-type": "application/json"]
     }

     var validationType: ValidationType {
          .successCodes
     }
}
