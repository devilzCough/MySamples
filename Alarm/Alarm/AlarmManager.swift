//
//  AlarmManager.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import Foundation

struct Alarm: Comparable {
    
    var id = -1
    var time: Date
    var displayedTime: String {
        return time.convertToString(format: .displayTime)
    }
    var soundIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var isOn = true
    
    static func < (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.time < rhs.time
    }
}

struct Sound {
    let title: String
}

class AlarmManager {
    
    static let shared = AlarmManager()
    
    private var alarms: [[Alarm]] = [
        [Alarm(time: Date()), Alarm(time: Date(timeIntervalSinceNow: 5000))],
        [Alarm(time: Date(timeIntervalSinceNow: 2300), isOn: false), Alarm(time: Date(timeIntervalSinceNow: 1488), isOn: false)]
    ]
    
    private let soundList = [
        [Sound(title: "Alarm Clock"),
         Sound(title: "Maple Leaf Rag")]
    ]
    
    // Alarms
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
    
    func setAlarm(to alarm: Alarm, at indexPath: IndexPath) {
        alarms[indexPath.section][indexPath.row] = alarm
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
    
    // Sounds
    func getSoundTitle(at indexPath: IndexPath) -> String {
        return soundList[indexPath.section][indexPath.row].title
    }
    
    
    
    var soundSectionCount: Int {
        get {
            return soundList.count
        }
    }
    
    func soundCount(of section: Int) -> Int {
        return soundList[section].count
    }
}
