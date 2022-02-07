//
//  ViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

// test
import UserNotifications

class AlarmListViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    
    private let alarmManager = AlarmManager.shared
    
    private let sections = [
        "대기 중 알람",
        "기타"
    ]
    
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
    
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
        requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        let authOption = UNAuthorizationOptions(arrayLiteral: .alert, .sound, .badge)
        alarmManager.notification.requestAuthorization(options: authOption) { success, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            
            let alarmDetailVC = navigation.topViewController as? AlarmDetailViewController
            alarmDetailVC?.delegate = self
            
            if segue.identifier == "AlarmEditSegue" {
                alarmDetailVC?.title = "알람 편집"
                alarmDetailVC?.editMode = true
                if let indexPath = alarmTableView.indexPathForSelectedRow {
                    alarmDetailVC?.indexPath = indexPath
                    alarmDetailVC?.alarm = alarmManager.getAlarm(at: indexPath.row, in: indexPath.section)
                }
            }
        }
    }
    
    @objc func didTapDoneButton() {
        
        navigationItem.leftBarButtonItem = editButton
        alarmTableView.setEditing(false, animated: true)
    }
    
    @IBAction func didTapEditButton(_ sender: UIBarButtonItem) {
        
        guard !alarmManager.isEmpty else { return }
        navigationItem.leftBarButtonItem = doneButton
        alarmTableView.setEditing(true, animated: true)
    }
}

extension AlarmListViewController: AlarmEditingDelegate {
    
    func saveAlarm(alarm: Alarm) {
        alarmManager.add(alarm: alarm)
        alarmTableView.reloadData()
    }
    
    func editAlarm(at indexPath: IndexPath, alarm: Alarm) {
        alarmManager.setAlarm(to: alarm, at: indexPath)
        alarmTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func deleteAlarm(at indexPath: IndexPath) {
        alarmManager.delete(alarmRowAt: indexPath)
        alarmTableView.reloadData()
    }
}

extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmManager.count(of: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(alarm: alarmManager.getAlarm(at: indexPath.row, in: indexPath.section))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        alarmManager.delete(alarmRowAt: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if alarmManager.isEmpty {
            didTapDoneButton()
        }
    }
    
    // Header
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

extension AlarmListViewController: AlarmCellDelegate {
    
    func alarmSwitched(to isOn: Bool, _ indexPath: IndexPath) {
        alarmManager.alarmSwitched(to: isOn, alarmRowAt: indexPath)
        alarmTableView.reloadData()
    }
}
