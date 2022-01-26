//
//  AlarmManager.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import Foundation
import UserNotifications
import UIKit

struct Alarm: Comparable {
    
    var id = -1
    let identifier = UUID()
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
    
    let notification = UNUserNotificationCenter.current()
    
    private var alarms: [[Alarm]] = [
        [Alarm(time: Date(timeIntervalSinceNow: 7000)), Alarm(time: Date(timeIntervalSinceNow: 5000))],
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
        
        if alarm.isOn {
            notification.removePendingNotificationRequests(withIdentifiers: [alarm.identifier.uuidString])
            scheduleAlarm(alarm: alarm)
        }
    }
    
    func add(alarm: Alarm) {
        alarms[0].append(alarm)
        alarms[0].sort()
        
        scheduleAlarm(alarm: alarm)
    }
    
    func delete(alarmRowAt indexPath: IndexPath) {
        let alarm = alarms[indexPath.section].remove(at: indexPath.row)
        if alarm.isOn {
            notification.removePendingNotificationRequests(withIdentifiers: [alarm.identifier.uuidString])
        }
    }
    
    func alarmSwitched(to isOn: Bool, alarmRowAt indexPath: IndexPath) {
        
        let section = isOn ? 0 : 1
        alarms[indexPath.section][indexPath.row].isOn = isOn
        
        let alarm = alarms[indexPath.section].remove(at: indexPath.row)
        alarms[section].append(alarm)
        alarms[section].sort()
        
        // Off -> ON
        if isOn {
            scheduleAlarm(alarm: alarm)
        // ON -> OFF
        } else {
            notification.removePendingNotificationRequests(withIdentifiers: [alarm.identifier.uuidString])
        }
    }
    
    private func scheduleAlarm(alarm: Alarm) {
        
        let content = UNMutableNotificationContent()

        content.title = "알람"
        content.body = "이것은 알림을 테스트 하는 것이다"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: getSoundTitle(at: alarm.soundIndexPath) + ".mp3"))
        
        let calendar = Calendar.current
        let date = calendar.dateComponents([.day, .hour, .minute], from: alarm.time)
        print(date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: alarm.identifier.uuidString,
                                           content: content,
                                           trigger: trigger)

        notification.add(request) { error in
           if let error = error {
               print("Notification Error: ", error)
           }
        }
    }
    
    // Sounds
    var soundSectionCount: Int {
        get {
            return soundList.count
        }
    }
    
    func soundCount(of section: Int) -> Int {
        return soundList[section].count
    }
    
    func getSoundTitle(at indexPath: IndexPath) -> String {
        return soundList[indexPath.section][indexPath.row].title
    }
}
