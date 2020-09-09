//
//  SignInResponse.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

struct SignInResponse: Codable {
    var jwt: String
    var nickname: String
    var uid: String
    var provider: String
}
