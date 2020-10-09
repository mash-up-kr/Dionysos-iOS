//
//  MainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Promises
import UIKit

final class SelectClockTypeViewController: UIViewController {
    // MARK: Properties
    
    @IBOutlet private weak var accumulatedTimeLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var stopWatchLabel: UILabel!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(MainTabCenter.default.getMainTab())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetLabels()
        view.addSubview(MainTabCenter.default.getMainTab())
        setupDurationLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupDurationLabel() {
        Promise.start {
            DionysosProvider.getTimeHistory()
        }.then(on: .main) { [weak self] timeHistory in
            let timeAmount = TimeAmount(timeHistory.duration)
            self?.accumulatedTimeLabel.text = timeAmount.description
        }
    }
    
    @IBAction private func timerDidTap(_ sender: Any) {
        toggleUnderLine(on: timerLabel)
        deactiveUnderline(on: stopWatchLabel)
        
        let viewController: TimeSettingViewController = .instantiate()
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func stopWatchDidTap(_ sender: Any) {
        toggleUnderLine(on: stopWatchLabel)
        deactiveUnderline(on: timerLabel)
        let questionView: QuestionView = .init(frame: QuestionView.Metric.defaultFrame)
        let alert: MGKAlertViewController = .instantiate(with: questionView)
        self.present(alert, animated: false)
        
        alert.promise.then { [weak self] _ in
            self?.resetLabels()
        }
        
        Promise<Bool> {
            questionView.promise
        }.then { answer in
            Promise<Bool> { fulfill, _ in alert.dismiss(animated: false) { fulfill(answer) } }
        }.then { needsTimeLapse in
            let viewController: UIViewController
            if needsTimeLapse {
                // 📽 타임 랩스 화면 랜딩
                viewController = TimeLapsViewController.instantiate(with: .stopwatch)
            } else {
                viewController = ClockViewController.instantiate(with: .stopwatch)
            }
            let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    typealias KeyValue = (key: NSAttributedString.Key, value: Any)
    private func toggleUnderLine(on label: UILabel) {
        guard let attributeText = label.attributedText else { return }
        let toggledLineStyle: NSUnderlineStyle = {
            let lineSet: KeyValue? = attributeText.attributes(at: 0, effectiveRange: nil)
                .first { $0.0 == .underlineStyle }
            return lineSet?.value as? Int ?? -10 != NSUnderlineStyle.single.rawValue ? NSUnderlineStyle.single : NSUnderlineStyle.byWord
        }()
        let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributeText)
        text.addAttributes([.underlineStyle: toggledLineStyle.rawValue], range: NSRange(0..<attributeText.length))
        label.attributedText = text
    }
    
    private func deactiveUnderline(on label: UILabel) {
        guard let attributeText = label.attributedText else { return }
        let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributeText)
        text.addAttributes([.underlineStyle: NSUnderlineStyle.byWord.rawValue], range: NSRange(0..<attributeText.length))
        label.attributedText = text
    }
    
    private func resetLabels() {
        deactiveUnderline(on: timerLabel)
        deactiveUnderline(on: stopWatchLabel)
    }
    
    static func instantiate() -> SelectClockTypeViewController {
        let viewController: SelectClockTypeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! SelectClockTypeViewController
//        let viewController: SelectClockTypeViewController = naviController.viewControllers.first as! SelectClockTypeViewController
        return viewController
    }
}
