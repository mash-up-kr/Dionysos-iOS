//
//  MGKTimer.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation
import Promises

class MGKTimer {
    // MARK: Properties
    
    private var timer: Timer?
    private var timeTasks: [TimeTask] = []
    private var updateHandler: ((TimeInterval) -> Void)?
    var accumulatedTime: TimeInterval {
        timeTasks.filter { $0.state != .todo }
            .map { TimeAmount(from: $0.startDate ?? Date(), to: $0.endDate ?? Date()) }
            .reduce(.zero, +)
            .timeInterval
    }
    
    private init() {}
    
    func run() {
        let task: TimeTask = TimeTask()
        timeTasks.append(task)
        configureTimer()
    }
    
    func pause() {
        guard let task = timeTasks.last,
            case .inProgress = task.state
            else { return }
        task.state = .done
        clearTimer()
    }
    
    private func configureTimer() {
        let newTimer: Timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateHandler?(self.accumulatedTime)
        }
        self.timer = newTimer
        RunLoop.current.add(newTimer, forMode: .common)
    }
    
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
}
extension MGKTimer {
    enum Status {
        case todo
        case inProgress
        case onPause
        case done
    }
}
