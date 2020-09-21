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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction private func timerDidTap(_ sender: Any) {
        toggleUnderLine(on: timerLabel)
        deactiveUnderline(on: stopWatchLabel)
        
        let viewController: TimeSettingViewController = .instantiate()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func stopWatchDidTap(_ sender: Any) {
        toggleUnderLine(on: stopWatchLabel)
        deactiveUnderline(on: timerLabel)
        let questionView: QuestionView = .init(frame: QuestionView.Metric.defaultFrame)
        let alert: MGKAlertViewController = .instantiate(with: questionView)
        self.present(alert, animated: false)
        
        // ⚪️ 타입 랩스와 스톱워치 선택 시 레이블 하이라이팅 취소 로직 추가
        alert.promise.then { [weak self] _ in
            self?.resetLabels()
        }
        
        Promise<Bool> {
            questionView.promise
        }.then { answer in
            Promise<Bool> { fulfill, _ in alert.dismiss(animated: false) { fulfill(answer) } }
        }.then { needsTimeLapse in
            if needsTimeLapse {
                // Todo: 📽 타임 랩스 화면 랜딩 추가
            } else {
                let viewController: ClockViewController = .instantiate(with: .stopwatch)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
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
        let naviController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController: SelectClockTypeViewController = naviController.viewControllers.first as! SelectClockTypeViewController
        return viewController
    }
}
