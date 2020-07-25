//
//  QuestionView.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/26.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

final class QuestionView: UIView {
    // MARK: Properties
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var tipLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    init() {
        super.init(frame: .zero)
        
        let nib: UINib = UINib(nibName: "QuestionView", bundle: nil)
        let view: UIView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        let contentView: UIView = view.subviews.first!
        self.frame = contentView.frame
        self.addSubview(contentView)
        self.backgroundColor = .white
//        contentView.frame.origin = .zero
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
