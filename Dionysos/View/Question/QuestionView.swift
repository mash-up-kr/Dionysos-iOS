//
//  QuestionView.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Promises
import UIKit

final class QuestionView: UIView, XibLoadable, Promisable {
    typealias Value = Bool
    
    // MARK: Constants
    
    enum Metric {
        static let defaultFrame: CGRect = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height / 3
        )
    }
    
    // MARK: Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: Methods
    
    override init(frame: CGRect = Metric.defaultFrame) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    @IBAction private func yesButtonDidTap(_ sender: Any) {
        promise.fulfill(true)
    }
    
    @IBAction private func noButtonDidTap(_ sender: Any) {
        promise.fulfill(false)
    }
}
