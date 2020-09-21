//
//  MGKAlertViewController.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/07/25.
//  Copyright © 2020 Mashup. All rights reserved.
//

import Promises
import UIKit

final class MGKAlertViewController: UIViewController, Promisable {
    enum Value {
        case dismiss
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    var contentView: UIView? {
        didSet {
            guard let contentView = contentView else { return }
            loadViewIfNeeded()
            configure(contentView)
        }
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true
        view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.16)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let contentView: UIView = self.contentView {
            configure(contentView)
        }
        slideUpContentView()
    }
    
    private func configure(_ contentView: UIView) {
        containerView.addSubview(contentView)
        contentView.frame.origin = .zero
    }
    
    private func slideUpContentView(withDuration duration: TimeInterval = 0.3) {
        containerHeightConstraint.constant = contentView?.bounds.height ?? 0
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
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
        self.dismiss(animated: true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        slideDownContentView()
            .then(on: .main) {
                super.dismiss(animated: flag, completion: completion)
                self.promise.fulfill(.dismiss)
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
    
    static func instantiate(with contentView: UIView) -> Self {
        let viewController: Self = Self.instantiate()
        viewController.contentView = contentView
        return viewController
    }
    
    static func show(with contentView: UIView) {
        let viewController: MGKAlertViewController = .instantiate(with: contentView)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController?.presentedViewController?.present(viewController, animated: false, completion: nil)
    }
}
