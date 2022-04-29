//
//  AddDailyGoalsViewController.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 27/04/22.
//

import UIKit

protocol AddDailyGoalsControllerDelegate: AnyObject {
    func reloadTableData(currentTabIndex: Int)
}

class AddDailyGoalsController: UIViewController {
    @IBOutlet weak var goalsNameInput: UITextField!
    @IBOutlet weak var goalsTimeInput: UIDatePicker!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var btnDeleteView: UIView!
    
    // Got from previous screen
    weak var delegate: AddDailyGoalsControllerDelegate?
    var currentTabIndex: Int = 0
    
    var goals: Goals?
    var chosenPriorityIndex: Int = Const.DefaultMasterGoalsPriority
    var chosenStatusIndex: Int = Const.DefaultMasterGoalsStatus

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goals != nil {
            prepareForEdit()
        } else {
            prepareForAdd()
        }
        
        preparePriorityButton()
        prepareStatusButton()
    }
    
    func prepareForAdd() {
        // Set Title
        title = "Add Daily Goals"
        
        statusView.isHidden = true
        btnDeleteView.isHidden = true
    }
    
    func prepareForEdit() {
        // Set Title
        title = "Daily Goals"
        
        statusView.isHidden = false
        btnDeleteView.isHidden = false
        
        // Set Current Value
        goalsNameInput.text = goals?.name
        goalsTimeInput.date = Calendar.current.date(from: DateComponents(hour: goals?.getHourOnly(), minute: goals?.getMinuteOnly())) ?? Date()
        chosenPriorityIndex = goals?.priorityIdx ?? Const.DefaultMasterGoalsPriority
        chosenStatusIndex = goals?.statusIdx ?? Const.DefaultMasterGoalsStatus
    }
    
    func preparePriorityButton() {
        let optionClosure = {(action: UIAction) in
            for (idx, masterPriority) in Const.MasterGoalsPriority.enumerated() {
                if action.title == masterPriority.name {
                    self.chosenPriorityIndex = idx
                    break
                }
            }
        }
        
        var actionLists = [UIAction]()
        for (idx, masterPriority) in Const.MasterGoalsPriority.reversed().enumerated() {
            actionLists.append(UIAction(
                title: masterPriority.name,
                image: masterPriority.image,
                state: (Const.MasterGoalsPriority.count - 1 - idx) == chosenPriorityIndex ? .on : .off, handler: optionClosure)
            )
        }

        priorityButton.menu = UIMenu(children: actionLists)
        
        priorityButton.showsMenuAsPrimaryAction = true
        priorityButton.changesSelectionAsPrimaryAction = true
    }
    
    func prepareStatusButton() {
        let optionClosure = {(action: UIAction) in
            for (idx, masterStatus) in Const.MasterGoalsStatus.enumerated() {
                if action.title == masterStatus {
                    self.chosenStatusIndex = idx
                    break
                }
            }
        }
        
        var actionLists = [UIAction]()
        for (idx, masterStatus) in Const.MasterGoalsStatus.reversed().enumerated() {
            actionLists.append(UIAction(
                title: masterStatus,
                state: (Const.MasterGoalsStatus.count - 1 - idx) == chosenStatusIndex ? .on : .off, handler: optionClosure)
            )
        }

        statusButton.menu = UIMenu(children: actionLists)
        
        statusButton.showsMenuAsPrimaryAction = true
        statusButton.changesSelectionAsPrimaryAction = true
    }
    
    
    @IBAction func saveButtonOnTapped(_ sender: Any) {
        guard let name = goalsNameInput?.text else {
            return
        }
        
        guard let dateTime = goalsTimeInput?.date else {
            return
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dateTime)
        let minute = calendar.component(.minute, from: dateTime)
        
        goals = Goals(name: name, minutes: (hour * 60 + minute), priorityIdx: chosenPriorityIndex, statusIdx: Const.GoalsStatusActive)
        
        // save the goals data
        print("=== SAVE DATA ===")
        print("name : \(goals?.name)")
        print("minutes : \(goals?.getFormattedMinutes())")
        print("priority : \(goals?.getGoalsPriority().name)")
        print("status : \(goals?.getStatusName())")
        
        self.dismiss(animated: true) {
            self.delegate?.reloadTableData(currentTabIndex: self.currentTabIndex)
        }
    }
    
    
    @IBAction func cancelButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
