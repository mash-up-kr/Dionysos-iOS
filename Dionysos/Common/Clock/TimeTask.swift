//
//  TimeTask.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

class TimeTask {
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    var state: State = .todo {
        didSet {
            switch state {
            case .todo:
                return
            case .inProgress:
                self.startDate = Date()
            case .done:
                self.endDate = Date()
            }
        }
    }
    
    enum State {
        case todo
        case inProgress
        case done
    }
}

func useCase() {}
