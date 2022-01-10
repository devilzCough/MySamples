//
//  AlarmManager.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import Foundation

struct Alarm {
    var id = -1
    var time: String
    var isOn = true
}

class AlarmManager {
    
    static let shared = AlarmManager()
    
    private var alarms: [Alarm] = [
        Alarm(time: "오전 10:00"),
        Alarm(time: "오후 3:20")
    ]
//    private var onAlarms: [Alarm] = []
//    private var offAlarms: [Alarm] = []
    
    var count: Int {
        get {
            return alarms.count
        }
    }
    
    func getAlarm(at index: Int) -> Alarm {
        return alarms[index]
    }
    
    func add(alarm: Alarm) {
        alarms.append(alarm)
    }
    
    func alarmSwitched(to isOn: Bool, alarmRowAt index: Int) {
        alarms[index].isOn = isOn
    }
    
    func setAlarmTime(to time: String, at index: Int) {
        alarms[index].time = time
    }
}
