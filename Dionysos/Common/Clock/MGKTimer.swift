//
//  MGKTimer.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

final class MGKTimer: Clock {
    var timer: Timer?
    var timeTasks: [TimeTask] = []
    private var timeUpdateHandler: TimeHandler?
    private var statusUpdateHandler: StatusHandler?
    var status: Status = .onPause {
        didSet { statusUpdateHandler?(status) }
    }
    private let targetTime: TimeInterval
    var accumulatedTime: TimeInterval {
        timeTasks.filter { $0.state != .todo }
            .map { TimeAmount(from: $0.startDate ?? Date(), to: $0.endDate ?? Date()) }
            .reduce(.zero, +)
            .timeInterval
    }
    
    init(
        targetTime: TimeAmount,
        timeUpdateHandler: @escaping TimeHandler = { _ in },
        statusUpdateHandler: @escaping StatusHandler = { _ in }
    ) {
        self.targetTime = targetTime.timeInterval
        self.timeUpdateHandler = timeUpdateHandler
        self.statusUpdateHandler = statusUpdateHandler
    }
    
    deinit {
        clearTimer()
    }
    
    func run() {
        let task: TimeTask = TimeTask()
        timeTasks.append(task)
        task.state = .inProgress
        self.status = .inProgress
        configureTimer()
    }
    
    func pause() {
        guard let task = timeTasks.last,
            case .inProgress = task.state
            else { return }
        task.state = .done
        self.status = .onPause
        clearTimer()
    }
    
    @discardableResult
    func end() -> TimeInterval {
        pause()
        self.status = .done
        return accumulatedTime
    }
    
    private func configureTimer() {
        let newTimer: Timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let remainingTime: TimeInterval = self.targetTime - self.accumulatedTime
            self.timeUpdateHandler?(remainingTime)
            if remainingTime == 0 {
                self.end()
            }
        }
        self.timer = newTimer
        RunLoop.current.add(newTimer, forMode: .common)
    }
    
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
}
