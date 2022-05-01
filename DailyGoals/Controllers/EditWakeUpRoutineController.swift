//
//  EditWakeUpRoutineController.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import UIKit

class EditWakeUpRoutineController: UIViewController {

    @IBOutlet weak var sunMonSameView: UIView!
    @IBOutlet weak var sunMonDifferentView: UIView!
    
    @IBOutlet weak var activatePushNotifSwitch: UISwitch!
    @IBOutlet weak var sunMonSwitch: UISwitch!
    
    @IBOutlet weak var sunMonTime: UIDatePicker!
    @IBOutlet weak var monTime: UIDatePicker!
    @IBOutlet weak var tueTime: UIDatePicker!
    @IBOutlet weak var wedTime: UIDatePicker!
    @IBOutlet weak var thuTime: UIDatePicker!
    @IBOutlet weak var friTime: UIDatePicker!
    @IBOutlet weak var satTime: UIDatePicker!
    @IBOutlet weak var sunTime: UIDatePicker!
    
    let wakeUpTimeHolder = WakeUpTimeHolder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isSunMonSame = true
        var isActivatePushNotif = true
        var sunMonDate: Date = Helper.stringToDateTime("14:00", "HH:mm")
        
        if let wakeUpTimeData = wakeUpTimeHolder.retrieve() {
            // Prepare data
            if wakeUpTimeData.count > 0 {
                let tempTimeString = Helper.dateTimeToString(wakeUpTimeData[0].dateTime)
                isActivatePushNotif = wakeUpTimeData[0].isRemind
                
                for wakeUpTime in wakeUpTimeData {
                    sunMonDate = wakeUpTime.dateTime
                
                    if Helper.dateTimeToString(wakeUpTime.dateTime) != tempTimeString {
                        isSunMonSame = false
                    }
                    
                    switch wakeUpTime.dayOfWeek {
                    case DayOfWeek.monday.rawValue:
                        monTime.date = wakeUpTime.dateTime.toGlobalTime()
                    case DayOfWeek.tuesday.rawValue:
                        tueTime.date = wakeUpTime.dateTime.toGlobalTime()
                    case DayOfWeek.wednesday.rawValue:
                        wedTime.date = wakeUpTime.dateTime.toGlobalTime()
                    case DayOfWeek.thursday.rawValue:
                        thuTime.date = wakeUpTime.dateTime.toGlobalTime()
                    case DayOfWeek.friday.rawValue:
                        friTime.date = wakeUpTime.dateTime.toGlobalTime()
                    case DayOfWeek.saturday.rawValue:
                        satTime.date = wakeUpTime.dateTime.toGlobalTime()
                    case DayOfWeek.sunday.rawValue:
                        sunTime.date = wakeUpTime.dateTime.toGlobalTime()
                    default:
                        print("Invalid Day Of Week")
                    }
                }
            }
        }
        
        if isSunMonSame {
            sunMonTime.date = sunMonDate.toGlobalTime()
        }
        
        sunMonSwitch.isOn = isSunMonSame
        sunMonSameView.isHidden = !isSunMonSame
        sunMonDifferentView.isHidden = isSunMonSame
        
        activatePushNotifSwitch.isOn = isActivatePushNotif
    }
    
    @IBAction func sunMonSameOnToggled(_ sender: UISwitch) {
        if sender.isOn {
            sunMonDifferentView.isHidden = true
            sunMonSameView.isHidden = false
        } else {
            sunMonSameView.isHidden = true
            sunMonDifferentView.isHidden = false
        }
    }
    
    @IBAction func activatePushNotifOnToggled(_ sender: UISwitch) {
        if sender.isOn {
            print("REGISTER PUSH NOTIF")
        } else {
            print("UNREGISTER PUSH NOTIF")
        }
    }
    
    
    @IBAction func cancelButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
        
        if !wakeUpTimeHolder.deleteAll() {
            print("Something Wrong on wakeUpTimeHolder.deleteAll()")
        }
        
        var wakeUpTimeNew = [WakeUpTimeModel]()
        if sunMonSwitch.isOn {
            for day in DayOfWeek.allCases {
                wakeUpTimeNew.append(
                    WakeUpTimeModel(
                        dateTime: sunMonTime.date.toLocalTime(),
                        dayOfWeek: day.rawValue,
                        isRemind: activatePushNotifSwitch.isOn
                    )
                )
            }
        } else {
            // Monday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: monTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.monday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
            // Tuesday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: tueTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.tuesday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
            // Wednesday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: wedTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.wednesday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
            // Thursday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: thuTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.thursday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
            // Friday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: friTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.friday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
            // Saturday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: satTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.saturday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
            // Sunday
            wakeUpTimeNew.append(
                WakeUpTimeModel(
                    dateTime: sunTime.date.toLocalTime(),
                    dayOfWeek: DayOfWeek.sunday.rawValue,
                    isRemind: activatePushNotifSwitch.isOn
                )
            )
        }
        
        if !wakeUpTimeHolder.create(wakeUpTimeData: wakeUpTimeNew) {
            print("Something Wrong on wakeUpTimeHolder.create()")
        }
    }
}
