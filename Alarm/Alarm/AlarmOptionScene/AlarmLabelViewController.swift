//
//  AlarmLabelViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/02/04.
//

import UIKit

class AlarmLabelViewController: UIViewController {

    @IBOutlet weak var labelTextField: UITextField!
    
    var label = "알람"
    
    weak var delegate: AlarmOptionSelecting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTextField.delegate = self
        
        labelTextField.text = label
        labelTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.alarmLabelTyped(as: labelTextField.text ?? "알람")
    }
}

extension AlarmLabelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        delegate?.alarmLabelTyped(as: textField.text ?? "알람")
//        dismiss(animated: true, completion: nil)
        
        return true
    }
}
