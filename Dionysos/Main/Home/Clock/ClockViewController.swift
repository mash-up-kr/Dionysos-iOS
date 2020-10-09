//
//  ClockViewController.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/08.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Promises
import UIKit

final class ClockViewController: UIViewController {
    // MARK: Properties
    
    @IBOutlet private weak var accumulatedTimeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var playAndPauseButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    // 누적 시간 초기값
    private var initalUserAccumulatedTime: TimeAmount?
    // 현재 타이머로 인해 더해진 누적 시간
    private var userAccumulatedTime: TimeAmount? {
        didSet { updateAccumulatedTimeLabel() }
    }
    private var clock: Clock!
    private var strategy: TimeMesureStrategy! {
        didSet { self.setupClock(for: strategy) }
    }
    private var isTimeOut: Bool = false {
        didSet {
            if self.isTimeOut {
                stopButton.isHidden = !isTimeOut
                self.timeLabel.textColor = UIColor(red: 252.0 / 255.0, green: 90.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
            }
        }
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        guard let strategy = strategy else { return }
        switch strategy {
        case .timer(let targetTime):
            updateTime(from: targetTime.timeInterval)
        case .stopwatch:
            updateTime(from: 0)
        }
        setupDurationLabel()
    }
    
    private func updateAccumulatedTimeLabel() {
        accumulatedTimeLabel.text = userAccumulatedTime?.description
    }
    
    private func setupClock(for strategy: TimeMesureStrategy) {
        switch strategy {
        case .timer(let remainingTime):
            self.clock = MGKTimer(
                targetTime: remainingTime,
                timeUpdateHandler: updateTime(from:),
                statusUpdateHandler: updatePlayAndPauseButton(from:)
            )
        case .stopwatch:
            self.clock = Stopwatch(
                timeUpdateHandler: updateTime(from:),
                statusUpdateHandler: updatePlayAndPauseButton(from:)
            )
        }
    }
    
    private func updateTime(from timeInterval: TimeInterval) {
        let time: TimeAmount = self.isTimeOut ? TimeAmount(-timeInterval) : TimeAmount(timeInterval)
        if clock is Stopwatch {
            userAccumulatedTime = (initalUserAccumulatedTime ?? .zero) + time
        } else {
            userAccumulatedTime = (initalUserAccumulatedTime ?? .zero) + TimeAmount(clock!.accumulatedTime)
        }
        isTimeOut = timeInterval < 0
        var timeString: String = [time.hours, time.minutes, time.seconds]
            .map { String(format: "%02d", $0) }
            .joined(separator: ":")
        if let index: String.Index = timeString.firstIndex(of: ":") {
            timeString.insert("\n", at: index)
        }
        let text: NSMutableAttributedString =
            NSMutableAttributedString(string: timeString)
        text.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(0..<text.length))
        timeLabel.attributedText = text
        
    }
    
    private func updatePlayAndPauseButton(from status: Clock.Status) {
        switch status {
        case .inProgress:
            playAndPauseButton.isSelected = true
            stopButton.isHidden = !isTimeOut
        case .onPause,
             .done:
            playAndPauseButton.isSelected = false
            stopButton.isHidden = false
        }
    }
    
    @IBAction private func playAndPauseButtonDidTap(_ sender: UIButton) {
        sender.isSelected ? clock.pause() : clock.run()
    }
    
    private func setupDurationLabel() {
        Promise.start {
            DionysosProvider.getTimeHistory()
        }.then(on: .main) { [weak self] timeHistory in
            let time = TimeAmount(timeHistory.duration)
            self?.initalUserAccumulatedTime = time
            self?.accumulatedTimeLabel.text = time.description
        }
    }
    
    @IBAction private func stopButtonDidTap(_ sender: UIButton) {
        let questionView = QuestionView(frame: QuestionView.Metric.defaultFrame)
        questionView.questionLabel.text = "정말 종료하시나요?"
        questionView.tipLabel.text = ""
        let alert = MGKAlertViewController.instantiate(with: questionView)
        self.present(alert, animated: false)
        Promise<Bool> {
            questionView.promise
        }.then { answer in
            // Alert 애니메이션 끝난 후
            Promise<Bool> { fulfill, _ in alert.dismiss(animated: false) { fulfill(answer) } }
        }.then { [weak self] answer in
            if let self = self, answer {
                self.requestAddTimeHistory().then(on: .main) { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            } else {
                alert.dismiss(animated: true, completion: nil)}
        }
    }
    
    private func requestAddTimeHistory() -> Promise<Void> {
        guard let duration = self.userAccumulatedTime?.timeInterval else { return .end }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = dateFormatter.string(from: Date())
        let timeStamp = "\(date)T\(time)"
        return DionysosProvider.addTimeHistory(duration: duration, timeStamp: timeStamp)
    }
}
extension ClockViewController {
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
enum TimeMesureStrategy {
    case timer(targetTime: TimeAmount)
    case stopwatch
}
