//
//  QuestionView.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class QuestionView: UIView, XibLoadable {
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
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var tipLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    var yesHandler: (() -> Void)?
    var noHandler: (() -> Void)?
    
    // MARK: Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    init(
        yesHandler: (() -> Void)? = nil,
        noHandler: (() -> Void)? = nil
    ) {
        super.init(frame: Metric.defaultFrame)
        self.yesHandler = yesHandler
        self.noHandler = noHandler
        
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    @IBAction private func yesButtonDidTap(_ sender: Any) {
        yesHandler?()
    }
    
    @IBAction private func noButtonDidTap(_ sender: Any) {
        noHandler?()
    }
}
