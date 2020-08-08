//
//  SettingTableViewCell.swift
//  Dionysos
//
//  Created by 김지혜 on 2020/08/05.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet private weak var settingTitle: UILabel!
    @IBOutlet private weak var settingContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSettings(title: String, content: String?) {
        self.settingTitle.text = title
        self.settingContent.text = content ?? ""
    }
}
