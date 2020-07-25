//
//  MainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit
import Promises

class MainViewController: UIViewController {
    
    @IBOutlet private weak var accumulatedTimeLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var stopWatchLabel: UILabel!
    
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
        toggleLine(on: timerLabel)
    }
    
    @IBAction private func stopWatchDidTap(_ sender: Any) {
        toggleLine(on: stopWatchLabel)
    }
    
    private func toggleLine(on label: UILabel) {
        guard let attributeText = label.attributedText else { return }
        let toggledLineStyle: NSUnderlineStyle = {
            let lineSet = attributeText.attributes(at: 0, effectiveRange: nil)
                .first { $0.0 == .underlineStyle }
            return lineSet?.value as? Int ?? -10 != NSUnderlineStyle.single.rawValue ? NSUnderlineStyle.single : NSUnderlineStyle.byWord
        }()
        let text = NSMutableAttributedString(attributedString: attributeText)
        text.addAttributes([.underlineStyle: toggledLineStyle.rawValue], range: NSRange(0..<attributeText.length))
        label.attributedText = text
    }
    
    static func instantiate() -> MainViewController {
        let naviController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController: MainViewController = naviController.viewControllers.first as! MainViewController
        return viewController
    }
}
