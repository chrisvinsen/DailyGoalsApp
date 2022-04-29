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
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var goalsNameInput: UITextField!
    @IBOutlet weak var goalsTimeInput: UIDatePicker!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var btnDeleteView: UIView!
    
    let goalsHolder = GoalsHolder()
    
    // Got from previous screen
    weak var delegate: AddDailyGoalsControllerDelegate?
    var currentTabIndex: Int = 0
    
    var goals: GoalsModel?
    var chosenPriorityIndex: Int = Const.DefaultMasterGoalsPriority
    var chosenStatusIndex: Int = Const.DefaultMasterGoalsStatus
    
    var isNewData = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goals != nil {
            prepareForEdit()
            isNewData = false
        } else {
            prepareForAdd()
            isNewData = true
        }
        
        preparePriorityButton()
        prepareStatusButton()
    }
    
    func prepareForAdd() {
        // Set Title
        title = "Add Daily Goals"
        if currentTabIndex == Const.TabTomorrowGoals {
            goalsLabel.text = "Tomorrow I Have to ..."
        } else {
            goalsLabel.text = "Today I Have to ..."
        }
        
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
        let name = goalsNameInput.text ?? ""
        if name == "" {
            return
        }
        
        guard let dateTime = goalsTimeInput?.date else {
            return
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dateTime)
        let minute = calendar.component(.minute, from: dateTime)
        
        var createdTime = Date()
        
        if currentTabIndex == Const.TabTomorrowGoals {
            createdTime = createdTime.nextDay
        } else if currentTabIndex == Const.TabYesterdayGoals {
            createdTime = createdTime.previousDay
        }
        
        if isNewData {
            // Create Data
            goals = GoalsModel(
                name: name,
                minutes: (hour * 60 + minute),
                priorityIdx: chosenPriorityIndex,
                statusIdx: Const.GoalsStatusActive,
                createdTime: createdTime.toLocalTime()
            )
            
            if !goalsHolder.create(goalsData: goals!) {
                print("Something Wrong on goalsHolder.create()")
            }
        } else {
            print("HERE")
            print(goals!)
            // Update Data
            goals?.name = name
            goals?.minutes = (hour * 60 + minute)
            goals?.priorityIdx = chosenPriorityIndex
            goals?.statusIdx = chosenStatusIndex
            
            if !goalsHolder.update(goalsData: goals!) {
                print("Something Wrong on goalsHolder.update()")
            }
        }
        
        self.delegate?.reloadTableData(currentTabIndex: self.currentTabIndex)
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func cancelButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteButtonOnTapped(_ sender: Any) {
        if !goalsHolder.delete(goalsData: goals!) {
            print("Something Wrong on goalsHolder.delete()")
        }
        
        self.delegate?.reloadTableData(currentTabIndex: self.currentTabIndex)
        
        self.dismiss(animated: true)
    }
}
