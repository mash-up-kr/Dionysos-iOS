//
//  NetworkErrorView.swift
//  Dionysos
//
//  Created by Jercy on 2020/09/10.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

protocol NetworkErrorRetryDelegate: AnyObject {
    func callRetry()
}

final class NetworkErrorView: UIView {
    private let xibName: String = "NetworkErrorView"
    private weak var delegate: NetworkErrorRetryDelegate?
    @IBAction private func networkErrorButtonAction(_ sender: UIButton) {
        delegate?.callRetry()
    }
    
    func setData(mainView: UIView?, delegate: NetworkErrorRetryDelegate?) {
        guard let mainView = mainView else { return }
        mainView.addSubview(self)
        isHidden = true
        self.delegate = delegate
        
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let view: UIView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        addSubview(view)
        backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
