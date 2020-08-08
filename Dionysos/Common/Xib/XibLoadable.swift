//
//  XibLoadable.swift
//  Dionysos
//
//  Created by dongyoung.lee on 2020/08/09.
//  Copyright © 2020 Mashup. All rights reserved.
//
˚
import UIKit

protocol XibLoadable {
    static var xibName: String { get }

    func setupNib()
    func loadNib() -> UIView?
}
extension XibLoadable where Self: UIView {
    static var xibName: String { String(describing: Self.self) }
    
    func setupNib() {
        guard let nib = loadNib() else { return }
        nib.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nib)
        NSLayoutConstraint.activate([
            nib.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nib.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nib.topAnchor.constraint(equalTo: self.topAnchor),
            nib.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func loadNib() -> UIView? {
        let bundle: Bundle = Bundle(for: Self.self)
        return bundle.loadNibNamed(Self.xibName, owner: self, options: nil)?.first as? UIView
    }
}
