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

