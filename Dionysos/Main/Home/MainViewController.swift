//
//  MainViewController.swift
//  Dionysos
//
//  Created by Jercy on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

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
        toggleLabelState(label: timerLabel)
        toggleLabelState(label: stopWatchLabel)
    }
    
    private func toggleLabelState(label: UILabel) {
        guard let attributeText = label.attributedText else { return }
        let text = NSMutableAttributedString(attributedString: attributeText)
        text.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(0..<attributeText.length))
        label.attributedText = text
    }
    
    static func instantiate() -> MainViewController {
        let naviController: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController: MainViewController = naviController.viewControllers.first as! MainViewController
        return viewController
    }
}
