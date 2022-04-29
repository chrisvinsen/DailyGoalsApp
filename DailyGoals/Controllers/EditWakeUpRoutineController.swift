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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default value
        sunMonSwitch.isOn = false
        sunMonDifferentView.isHidden = false
        sunMonSameView.isHidden = true
        activatePushNotifSwitch.isOn = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    }
    
    
}
