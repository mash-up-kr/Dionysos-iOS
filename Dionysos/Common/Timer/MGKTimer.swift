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
    typealias TimeHandler = (TimeInterval) -> Void
    // MARK: Properties
    private var timer: Timer?
    private var timeTasks: [TimeTask] = []
    private var updateHandler: TimeHandler?
    var accumulatedTime: TimeInterval {
        timeTasks.filter { $0.state != .todo }
            .map { TimeAmount(from: $0.startDate ?? Date(), to: $0.endDate ?? Date()) }
            .reduce(.zero, +)
            .timeInterval
    }
    
    init(updateHandler: @escaping TimeHandler = { _ in }) {
        self.updateHandler = updateHandler
    }
    
    deinit {
        clearTimer()
    }
    
    func run() {
        let task: TimeTask = TimeTask()
        timeTasks.append(task)
        task.state = .inProgress
        configureTimer()
    }
    
    func pause() {
        guard let task = timeTasks.last,
            case .inProgress = task.state
            else { return }
        task.state = .done
        clearTimer()
    }
    
    func end() -> TimeInterval {
        pause()
        return accumulatedTime
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
