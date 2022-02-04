//
//  AlarmOptionTableViewCell.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/17.
//

import UIKit

class AlarmOptionTableViewCell: UITableViewCell {
    
    static let identifier = "AlarmOptionTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(option: AlarmOption) {
        
        var content = defaultContentConfiguration()
        content.text = option.title
        
        if let detail = option.content {
            content.secondaryText = detail
        }
    
        switch option.type {
        case .disclosureCell:
            accessoryType = .disclosureIndicator
        case .switchCell:
            let reAlarmSwitch = UISwitch()
            reAlarmSwitch.isOn = true
            reAlarmSwitch.addTarget(self, action: #selector(didTapReAlarmSwitch), for: .valueChanged)
            accessoryView = reAlarmSwitch
        case .deleteCell:
            content.textProperties.color = .red
            content.textProperties.alignment = .center
        }
        
        contentConfiguration = content
    }

    @objc func didTapReAlarmSwitch(sender: UISwitch) {
        print(sender.isOn)
    }
}
