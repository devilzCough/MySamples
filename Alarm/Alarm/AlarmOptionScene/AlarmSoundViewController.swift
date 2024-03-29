//
//  AlarmSoundViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/18.
//

import UIKit

protocol AlarmOptionSelecting: AnyObject {
    func alarmLabelTyped(as label: String)
    func alarmSoundSelected(indexPath: IndexPath)
}

class AlarmSoundViewController: UIViewController {

    @IBOutlet weak var alarmSoundTableView: UITableView!
    
    var selectedSoundIndexPath = IndexPath(row: 0, section: 0)
    
    weak var delegate: AlarmOptionSelecting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alarmSoundTableView.delegate = self
        alarmSoundTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.alarmSoundSelected(indexPath: selectedSoundIndexPath)
    }
}

extension AlarmSoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmManager.shared.soundCount(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSoundTableViewCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = AlarmManager.shared.getSoundTitle(at: indexPath)
        if selectedSoundIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.contentConfiguration = content
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedSoundIndexPath = indexPath
        tableView.reloadData()
    }
}
