//
//  AlarmDetailViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

protocol AlarmSaving: AnyObject {
    func saveAlarm(time: String)
    func editAlarm(at indexPath: IndexPath, time: String)
}

struct AlarmOption {
    let title: String
    var content: String?
    let type: AlarmOptionCellType
}

enum AlarmOptionCellType {
    case disclosureCell
    case switchCell
    case deleteCell
}

class AlarmDetailViewController: UIViewController {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmOptionTableView: UITableView!
    
    private var alarmOptions = [
        [AlarmOption(title: "반복", content: "안 함", type: .disclosureCell),
         AlarmOption(title: "레이블", content: "알람", type: .disclosureCell),
         AlarmOption(title: "사운드", content: "벨", type: .disclosureCell),
         AlarmOption(title: "다시 알림", type: .switchCell)],
        [AlarmOption(title: "알람 삭제", type: .deleteCell)]
    ]
    
    weak var delegate: AlarmSaving?
    
    var time = Date()
    
    var editMode = false
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alarmDatePicker.date = time
        
        alarmOptionTableView.delegate = self
        alarmOptionTableView.dataSource = self
    }
    
    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        
        time = alarmDatePicker.date
        
        if editMode, let indexPath = indexPath {
            delegate?.editAlarm(at: indexPath, time: time.convertToString(format: .displayTime))
        } else {
            delegate?.saveAlarm(time: time.convertToString(format: .displayTime))
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AlarmDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmOptionTableViewCell.identifier, for: indexPath) as? AlarmOptionTableViewCell else { return UITableViewCell() }
        
        cell.configure(option: alarmOptions[indexPath.section][indexPath.row])

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return editMode ? alarmOptions.count : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "AlarmOptions", bundle: nil)
        
        switch indexPath.row {
        case 2:
            guard let vc = storyboard.instantiateViewController(identifier: "AlarmSoundViewController") as? AlarmSoundViewController else { return }
            
            vc.title = alarmOptions[indexPath.section][indexPath.row].title
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
