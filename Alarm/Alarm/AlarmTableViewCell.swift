//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

protocol AlarmCellDelegate: AnyObject {
    func alarmSwitched(to isOn: Bool, _ indexPath: IndexPath)
}

class AlarmTableViewCell: UITableViewCell {
    
    static let identifier = "AlarmTableViewCell"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    var indexPath: IndexPath?
    weak var delegate: AlarmCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(alarm: Alarm) {
        timeLabel.text = alarm.displayedTime
        onOffSwitch.isOn = alarm.isOn
    }
    
    @IBAction func didTapOnOffSwitch(_ sender: UISwitch) {
        
        guard let indexPath = indexPath else { return }
        print(sender.isOn)
        delegate?.alarmSwitched(to: sender.isOn, indexPath)
    }
}
