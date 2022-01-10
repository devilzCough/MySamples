//
//  ViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

struct Alarm {
    var time: String
    var isOn = true
}

class AlarmListViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    
    var alarms: [Alarm] = [
        Alarm(time: "오전 10:00"),
        Alarm(time: "오후 4:24")
    ]
    
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
                    alarmDetailVC?.time = alarms[selectedRow].time.convertToDate()
                }
            }
        }
    }
}

extension AlarmListViewController: AlarmSaving {
    
    func saveAlarm(time: String) {
        alarms.append(Alarm(time: time))
        alarmTableView.reloadData()
    }
    
    func editAlarm(at row: Int, time: String) {
        alarms[row] = Alarm(time: time)
        alarmTableView.reloadData()
    }
}

extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        
        cell.configure(alarm: alarms[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { _,_,success in
            print("Delete")
            success(true)
        }
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
