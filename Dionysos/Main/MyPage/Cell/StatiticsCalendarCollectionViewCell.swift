//
//  StatiticsCalendarCollectionViewCell.swift
//  Dionysos
//
//  Created by Jercy on 2020/08/06.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class StatiticsCalendarCollectionViewCell: UICollectionViewCell {
    enum Frequency: CaseIterable {
        case none
        case less
        case normal
        case more
        case most
        
        func getImage() -> UIImage {
            switch self {
            case .none:
                return UIImage(named: "39")!
            case .less:
                return UIImage(named: "40")!
            case .normal:
                return UIImage(named: "41")!
            case .more:
                return UIImage(named: "42")!
            case .most:
                return UIImage(named: "43")!
            }
        }
    }
    
    @IBOutlet private weak var backgroundFrequencyImageView: UIImageView!
    
    func setFrequency(_ frequency: Frequency) {
        backgroundFrequencyImageView.image = frequency.getImage()
    }
}
