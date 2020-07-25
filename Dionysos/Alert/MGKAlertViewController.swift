//
//  MGKAlertViewController.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit
import Promises

final class MGKAlertViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet private weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    var contentView: UIView? {
        didSet {
            guard let contentView = contentView else { return }
            guard self.isViewLoaded else { return }
            configure(contentView)
        }
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 30
        
        if let contentView: UIView = self.contentView {
            configure(contentView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.slideUpContentView()
    }
    
    private func configure(_ contentView: UIView) {
        self.containerView.addSubview(contentView)
    }
    
    private func slideUpContentView(withDuration duration: TimeInterval = 0.3) {
        containerHeightConstraint.constant = contentView?.bounds.height ?? 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func slideDownContentView(withDuration duration: TimeInterval = 0.3) -> Promise<Void> {
        Promise<Void> { [weak self] fulfill, _ in
            self?.containerHeightConstraint.constant = 0
            UIView.animate(
                withDuration: duration,
                animations: { self?.view.layoutIfNeeded() },
                completion: { _ in fulfill(Void()) }
            )
        }
    }
    
    // MARK: Actions
    @IBAction private func backgroundViewDidTap(_ sender: Any) {
        Promise.start {
            self.slideDownContentView()
        }.then {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
extension MGKAlertViewController {
    private static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: "MGKAlert", bundle: nil).instantiateInitialViewController() else {
            fatalError("load failure \(type(of: self))")
        }
        viewController.modalPresentationStyle = .overCurrentContext
        return viewController as! Self
    }
    private static func instantiate(with contentView: UIView) -> Self {
        let viewController: Self = Self.instantiate()
        viewController.contentView = contentView
        return viewController
    }
    
    static func show(with contentView: UIView) {
        let viewController: MGKAlertViewController = Self.instantiate(with: contentView)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController?.present(viewController, animated: false, completion: nil)
    }
}
