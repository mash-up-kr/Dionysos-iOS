//
//  ClockViewController.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/08.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class ClockViewController: UIViewController {
    // MARK: Properties
    @IBOutlet private weak var accumulatedTimeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var playAndPauseButton: UIButton!
    
    private var clock: Clock!
    private var strategy: TimeMesureStrategy! {
        didSet { self.setupClock(for: strategy) }
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if case let .timer(targetTime) = strategy {
            updateTimeLabel(from: targetTime.timeInterval)
        }
    }
    
    private func setupClock(for strategy: TimeMesureStrategy) {
        switch strategy {
        case .timer(let remainingTime):
            self.clock = MGKTimer(
                targetTime: remainingTime,
                timeUpdateHandler: updateTimeLabel(from:),
                statusUpdateHandler: updatePlayAndPauseButton(from:)
            )
        case .stopwatch:
            self.clock = Stopwatch(
                timeUpdateHandler: updateTimeLabel(from:),
                statusUpdateHandler: updatePlayAndPauseButton(from:)
            )
        }
    }
    
    private func updateTimeLabel(from timeInterval: TimeInterval) {
        let time: TimeAmount = TimeAmount(timeInterval)
        var timeString: String = [time.hours, time.minutes, time.seconds]
            .map { String(format: "%02d", $0) }
            .joined(separator: ":")
        if let index: String.Index = timeString.firstIndex(of: ":") {
            timeString.insert("\n", at: index)
        }
        timeLabel.text = timeString
    }
    
    private func updatePlayAndPauseButton(from status: Clock.Status) {
        switch status {
        case .inProgress:
            playAndPauseButton.isSelected = true
        case .onPause,
             .done:
            playAndPauseButton.isSelected = false
        }
    }
    
    @IBAction private func playAndPauseButtonDidTap(_ sender: UIButton) {
        sender.isSelected ? clock.pause() : clock.run()
    }
}

extension ClockViewController {
    enum TimeMesureStrategy {
        case timer(targetTime: TimeAmount)
        case stopwatch
    }
    
    private static func instantiate() -> ClockViewController {
        let viewController: UIViewController? = UIStoryboard(name: "Clock", bundle: nil).instantiateInitialViewController()
        return viewController as! ClockViewController
    }
    
    static func instantiate(with strategy: TimeMesureStrategy) -> ClockViewController {
        let viewController: ClockViewController = ClockViewController.instantiate()
        viewController.strategy = strategy
        return viewController
    }
}
