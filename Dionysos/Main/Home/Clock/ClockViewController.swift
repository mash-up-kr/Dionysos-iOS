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
    
    private var clock: Clock {
        get { _clock! }
        set { _clock = newValue }
    }
    private var _clock: Clock?
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateTimeLabel(from timeInterval: TimeInterval) {
        let time: TimeAmount = TimeAmount(timeInterval)
        self.timeLabel.text = [time.hours, time.minutes, time.seconds]
            .map { String(format: "%02d", $0) }
            .joined(separator: ":")
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
        
    }
}
