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
    
    // test
    let notification = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
        // test
        requestNotificationAuthorization()
    }
    
    //test
    func requestNotificationAuthorization() {
        let authOption = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        notification.requestAuthorization(options: authOption) { success, error in
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
                    alarmDetailVC?.time = alarmManager.getAlarm(at: indexPath.row, in: indexPath.section).time.convertToDate()
                }
            }
        }
    }
    
    @IBAction func didTapTestButton(_ sender: UIBarButtonItem) {
        
        let content = UNMutableNotificationContent()

        content.title = "알림 테스트"
        content.body = "이것은 알림을 테스트 하는 것이다"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.mp3"))
        

        let seconds: Double = 10
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                           content: content,
                                           trigger: trigger)

        notification.add(request) { error in
           if let error = error {
               print("Notification Error: ", error)
           }
        }
    }
}

extension AlarmListViewController: AlarmSaving {
    
    func saveAlarm(time: String) {
        alarmManager.add(alarm: Alarm(time: time))
        alarmTableView.reloadData()
    }
    
    func editAlarm(at indexPath: IndexPath, time: String) {
        alarmManager.setAlarmTime(to: time, at: indexPath)
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
            self?.alarmManager.delete(alarmRowAt: indexPath)
            DispatchQueue.main.async {
                self?.alarmTableView.reloadData()
            }
            completion(true)
        }
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
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
