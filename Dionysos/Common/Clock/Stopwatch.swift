//
//  Stopwatch.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/08.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Foundation

final class Stopwatch: Clock {
    // MARK: Properties
    var timer: Timer?
    var timeTasks: [TimeTask] = []
    private var timeUpdateHandler: TimeHandler?
    private var statusUpdateHandler: StatusHandler?
    var status: Status = .onPause {
        didSet { statusUpdateHandler?(status) }
    }
    var accumulatedTime: TimeInterval {
        timeTasks.filter { $0.state != .todo }
            .map { TimeAmount(from: $0.startDate ?? Date(), to: $0.endDate ?? Date()) }
            .reduce(.zero, +)
            .timeInterval
    }
    
    init(
        timeUpdateHandler: @escaping TimeHandler = { _ in },
        statusUpdateHandler: @escaping StatusHandler = { _ in }
    ) {
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
        status = .inProgress
        configureTimer()
    }
    
    func pause() {
        guard let task = timeTasks.last,
            case .inProgress = task.state
            else { return }
        task.state = .done
        status = .onPause
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
            self.timeUpdateHandler?(self.accumulatedTime)
        }
        timer = newTimer
        RunLoop.current.add(newTimer, forMode: .common)
    }
    
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
}
