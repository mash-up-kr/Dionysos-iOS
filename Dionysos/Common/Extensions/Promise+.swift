//
//  Promise+Start.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Promises

extension Promise where Value == Void {
    static func start<Result>(
        on queue: DispatchQueue = .main,
        _ work: @escaping () -> Promise<Result>
    ) -> Promise<Result> {
        Promise<Void> {}.then { work() }
    }
    
    static func wrap<Result>(
           on queue: DispatchQueue = .main,
           _ work: @autoclosure @escaping () throws -> Result
    ) -> Promise<Result> {
        Promise<Result> { try work() }
    }
}
