//
//  DionysosProvider.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/22.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Moya

class DionysosProvider {
//    static let provider = MoyaProvider<ThingService>()
}

extension DionysosProvider {
    class func resultTask<T: Decodable>(_ result: Result<Response, MoyaError>, completion: @escaping ((T) -> Void), failure: @escaping ((Error) -> Void)) {
        switch result {
        case .success(let response):
            logger(try? response.mapJSON())
            let _: Data = response.data
            if let body: T = try? response.map(T.self) {
                completion(body)
            } else {
               failure(NSError(domain: "Unknown", code: -9_999, userInfo: nil))
            }
        case let .failure(error):
            failure(error)
        }
    }
}
