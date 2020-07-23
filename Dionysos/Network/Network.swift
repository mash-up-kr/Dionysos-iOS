//
//  Network.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/23.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Moya
import Promises

enum Network {
    // MARK: Properties
    
    private static let provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()
    
    // MARK: Method
    
    static func request<API: EndPointType>(_ api: API) -> Promise<API.Response> {
        request(api.toTarget()).then {
            try parse($0)
        }
    }
    
    static func request<Response: Decodable>(_ target: TargetType, to type: Response) -> Promise<Response> {
        request(target).then {
            try parse($0)
        }
    }
    
    static func request(_ target: TargetType) -> Promise<Data> {
        Promise<Data> { fulfill, reject in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    fulfill(response.data)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    private static func parse<Response: Decodable>(_ data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}
