//
//  AlarmDetailViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import UIKit

protocol AlarmSaving: AnyObject {
    func saveAlarm(time: String)
    func editAlarm(at row: Int, time: String)
}

class AlarmDetailViewController: UIViewController {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    
    weak var delegate: AlarmSaving?
    
    var time = Date()
    
    var editMode = false
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alarmDatePicker.date = time
    }
    
    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        
        time = alarmDatePicker.date
        
        if editMode, let row = selectedRow {
            delegate?.editAlarm(at: row, time: time.convertToString(format: .displayTime))
        } else {
            delegate?.saveAlarm(time: time.convertToString(format: .displayTime))
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
