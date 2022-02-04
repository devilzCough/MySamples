//
//  AlarmDetailViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

protocol AlarmEditingDelegate: AnyObject {
    func saveAlarm(alarm: Alarm)
    func editAlarm(at indexPath: IndexPath, alarm: Alarm)
    func deleteAlarm(at indexPath: IndexPath)
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
         AlarmOption(title: "레이블", type: .disclosureCell),
         AlarmOption(title: "사운드", type: .disclosureCell),
         AlarmOption(title: "다시 알림", type: .switchCell)],
        [AlarmOption(title: "알람 삭제", type: .deleteCell)]
    ]
    
    weak var delegate: AlarmEditingDelegate?
    
    var editMode = false
    var indexPath: IndexPath?
    
    let alarmManager = AlarmManager.shared
    var alarm = Alarm(time: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alarmDatePicker.date = alarm.time
        
        alarmOptionTableView.delegate = self
        alarmOptionTableView.dataSource = self
        
        configure()
    }
    
    private func configure() {
        alarmOptions[0][1].content = alarm.label
        alarmOptions[0][2].content = alarmManager.getSoundTitle(at: alarm.soundIndexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AlarmLabelSegue":
            let alarmLabelVC = segue.destination as? AlarmLabelViewController
            alarmLabelVC?.delegate = self
            alarmLabelVC?.label = alarm.label
            
        case "AlarmSoundSegue":
            let alarmSoundVC = segue.destination as? AlarmSoundViewController
            alarmSoundVC?.delegate = self
            alarmSoundVC?.selectedSoundIndexPath = alarm.soundIndexPath
        default:
            break
        }
    }
    
    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        
        alarm.time = alarmDatePicker.date
        
        if editMode, let indexPath = indexPath {
            delegate?.editAlarm(at: indexPath, alarm: alarm)
        } else {
            delegate?.saveAlarm(alarm: alarm)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AlarmDetailViewController: AlarmOptionSelecting {
    
    func alarmLabelTyped(as label: String) {
        alarm.label = label
        alarmOptions[0][1].content = label
        let indexPath = IndexPath(row: 1, section: 0)
        alarmOptionTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func alarmSoundSelected(indexPath: IndexPath) {
        alarm.soundIndexPath = indexPath
        alarmOptions[0][2].content = alarmManager.getSoundTitle(at: indexPath)
        let indexPath = IndexPath(row: 2, section: 0)
        alarmOptionTableView.reloadRows(at: [indexPath], with: .automatic)
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
        
        if indexPath.section == 1, let selectedIndexPath = self.indexPath {
            delegate?.deleteAlarm(at: selectedIndexPath)
            dismiss(animated: true, completion: nil)
        }
        
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "AlarmLabelSegue", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "AlarmSoundSegue", sender: nil)
        default:
            break
        }
    }
}
