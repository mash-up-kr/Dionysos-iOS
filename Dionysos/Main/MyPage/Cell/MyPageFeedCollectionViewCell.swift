//
//  MyPageFeedCollectionViewCell.swift
//  Dionysos
//
//  Created by Jercy on 2020/10/09.
//  Copyright © 2020 Mashup. All rights reserved.
//

import SDWebImage
import UIKit

final class MyPageFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var diaryImage: UIImageView!
    func setData(model: PurpleDiaryModel) {
        let url = URL(string: model.imageURL)
        diaryImage.sd_setImage(with: url, placeholderImage: UIImage(named: "icFiremanOn44Px"))
    }
}
