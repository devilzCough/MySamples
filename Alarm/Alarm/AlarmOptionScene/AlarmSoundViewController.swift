//
//  AlarmSoundViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/18.
//

import UIKit

class AlarmSoundViewController: UIViewController {

    @IBOutlet weak var alarmSoundTableView: UITableView!
    
    private var soundList = [
        "Alarm Clock",
        "Maple Leaf Rag"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alarmSoundTableView.delegate = self
        alarmSoundTableView.dataSource = self
    }
    
}

extension AlarmSoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmSoundTableViewCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = soundList[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
}
