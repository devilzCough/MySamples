//
//  AlarmOffViewController.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/12.
//

import UIKit

class AlarmOffViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAlarmOffButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
