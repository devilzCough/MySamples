//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    static let identifier = "AlarmTableViewCell"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(alarm: Alarm) {
        timeLabel.text = alarm.time
        onOffSwitch.isOn = alarm.isOn
    }
}
