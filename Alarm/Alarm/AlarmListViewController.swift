//
//  ViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

class AlarmListViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    
    private let alarmManager = AlarmManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            
            let alarmDetailVC = navigation.topViewController as? AlarmDetailViewController
            alarmDetailVC?.delegate = self
            
            if segue.identifier == "AlarmEditSegue" {
                alarmDetailVC?.title = "알람 편집"
                alarmDetailVC?.editMode = true
                if let selectedRow = alarmTableView.indexPathForSelectedRow?.row {
                    alarmDetailVC?.selectedRow = selectedRow
                    alarmDetailVC?.time = alarmManager.getAlarm(at: selectedRow).time.convertToDate()
                }
            }
        }
    }
}

extension AlarmListViewController: AlarmSaving {
    
    func saveAlarm(time: String) {
        alarmManager.add(alarm: Alarm(time: time))
        alarmTableView.reloadData()
    }
    
    func editAlarm(at row: Int, time: String) {
        alarmManager.setAlarmTime(to: time, at: row)
        alarmTableView.reloadData()
    }
}

extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmManager.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(alarm: alarmManager.getAlarm(at: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
            self?.alarmManager.delete(alarmRowAt: indexPath.row)
            DispatchQueue.main.async {
                self?.alarmTableView.reloadData()
            }
            completion(true)
        }
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension AlarmListViewController: AlarmCellDelegate {
    
    func alarmSwitched(to isOn: Bool, _ indexPath: IndexPath) {
        alarmManager.alarmSwitched(to: isOn, alarmRowAt: indexPath.row)
    }
}
