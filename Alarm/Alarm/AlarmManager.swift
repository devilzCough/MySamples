//
//  AlarmManager.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import Foundation

struct Alarm: Comparable {
    
    var id = -1
    var time: String
    var isOn = true
    
    static func < (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.time < rhs.time
    }
}

class AlarmManager {
    
    static let shared = AlarmManager()
    
    private var alarms: [[Alarm]] = [
        [Alarm(time: "오전 10:00"), Alarm(time: "오후 03:20")],
        [Alarm(time: "오전 05:23", isOn: false), Alarm(time: "오전 07:40", isOn: false)]
    ]
    
    var sectionCount: Int {
        get {
            return alarms.count
        }
    }
    
    func count(of section: Int) -> Int {
        return alarms[section].count
    }
    
    func getAlarm(at index: Int, in section: Int) -> Alarm {
        return alarms[section][index]
    }
    
    func setAlarmTime(to time: String, at indexPath: IndexPath) {
        alarms[indexPath.section][indexPath.row].time = time
    }
    
    func add(alarm: Alarm) {
        alarms[0].append(alarm)
        alarms[0].sort()
        print(alarms)
    }
    
    func delete(alarmRowAt indexPath: IndexPath) {
        alarms[indexPath.section].remove(at: indexPath.row)
    }
    
    func alarmSwitched(to isOn: Bool, alarmRowAt indexPath: IndexPath) {
        
        let section = isOn ? 0 : 1
        alarms[indexPath.section][indexPath.row].isOn = isOn
        
        let alarm = alarms[indexPath.section].remove(at: indexPath.row)
        alarms[section].append(alarm)
        alarms[section].sort()
    }
}
