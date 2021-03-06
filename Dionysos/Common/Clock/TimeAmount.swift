//
//  TimeAmount.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

struct TimeAmount {
    let timeInterval: TimeInterval
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.timeInterval = TimeInterval(hours * 3_600 + minutes * 60 + seconds)
    }
    
    init(_ timeInterval: TimeInterval) {
        let time: Int = Int(timeInterval)
        self.timeInterval = timeInterval
        self.hours = Int(time) / 3_600
        self.minutes = Int(time) / 60 % 60
        self.seconds = Int(time) % 60
    }
    
    init(from startDate: Date, to endDate: Date = Date()) {
        self.timeInterval = endDate.timeIntervalSince(startDate)
        let time: Int = Int(timeInterval)
        self.hours = Int(time) / 3_600
        self.minutes = Int(time) / 60 % 60
        self.seconds = Int(time) % 60
    }
}
extension TimeAmount {
    static let zero: TimeAmount = TimeAmount(0)
    static func + (lhs: Self, rhs: Self) -> Self {
        TimeAmount(lhs.timeInterval + rhs.timeInterval)
    }
}
extension TimeAmount: CustomStringConvertible {
    var description: String {
        [hours, minutes, seconds]
            .map { String(format: "%02d", $0) }
            .joined(separator: ":")
    }
}
