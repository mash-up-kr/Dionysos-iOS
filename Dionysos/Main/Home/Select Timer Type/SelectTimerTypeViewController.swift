//
//  MainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Promises
import UIKit

final class SelectTimerTypeViewController: UIViewController {
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction private func timerDidTap(_ sender: Any) {
        toggleUnderLine(on: timerLabel)
        deactiveUnderline(on: stopWatchLabel)
    }
    
    @IBAction private func stopWatchDidTap(_ sender: Any) {
        toggleUnderLine(on: stopWatchLabel)
        deactiveUnderline(on: timerLabel)
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
    
    static func instantiate() -> SelectTimerTypeViewController {
        let naviController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController: SelectTimerTypeViewController = naviController.viewControllers.first as! SelectTimerTypeViewController
        return viewController
    }
}
