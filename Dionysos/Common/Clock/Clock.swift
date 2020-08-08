//
//  Clock.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/08.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

enum ClockStatus {
    case inProgress
    case onPause
    case done
}

protocol Clock {
    typealias Status = ClockStatus
    typealias TimeHandler = (TimeInterval) -> Void
    typealias StatusHandler = (Status) -> Void
    var status: Status { get }
    var accumulatedTime: TimeInterval { get }
    
    func run()
    func pause()
    func end() -> TimeInterval
}
