//
//  ViewController.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 27/04/22.
//

import UIKit

class MyDailyGoalsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listOfGoals = [GoalsModel]() // Used on table view
    var listOfActiveGoals = [GoalsModel]()
    var listOfCompletedGoals = [GoalsModel]()
    
    let goalsHolder = GoalsHolder()
    
    var currentTabIndex: Int = 1
    var editGoals: GoalsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(Const.TabTodayGoals)
        
        // Register NIB for table cells
        tableView.register(UINib(nibName: "TodaySummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "TodaySummaryTableViewCell")
        tableView.register(UINib(nibName: "ActiveGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveGoalsTableViewCell")
        tableView.register(UINib(nibName: "SectionHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableViewCell")
        tableView.register(UINib(nibName: "EmptyDataTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyDataTableViewCell")
    }
    
    func loadData(_ tabChosen: Int) {
        var startDateTime: Date
        var endDateTime: Date
        
        let todayDate = Date()
        let day = todayDate.get(.day)
        let month = todayDate.get(.month)
        let year = todayDate.get(.year)
        
        switch tabChosen {
        case Const.TabYesterdayGoals: // YESTERDAY
            startDateTime = Helper.stringToDateTime("\(month)/\(day - 1)/\(year) 00:00:00")
            endDateTime = Helper.stringToDateTime("\(month)/\(day - 1)/\(year) 23:59:59")
        case Const.TabTomorrowGoals: // TOMORROW
            startDateTime = Helper.stringToDateTime("\(month)/\(day + 1)/\(year) 00:00:00")
            endDateTime = Helper.stringToDateTime("\(month)/\(day + 1)/\(year) 23:59:59")
        default: // TODAY AS DEFAULT
            startDateTime = Helper.stringToDateTime("\(month)/\(day)/\(year) 00:00:00")
            endDateTime = Helper.stringToDateTime("\(month)/\(day)/\(year) 23:59:59")
        }
        
        guard let loadedData = goalsHolder.retrieve(
            predicate: NSPredicate(format: "created_time >= %@ AND created_time <= %@", startDateTime.toLocalTime() as CVarArg, endDateTime.toLocalTime() as CVarArg),
            sortedByKey: "priority_idx",
            isAsc: false
        ) else {
            print("Something Wrong on goalsHolder.retrieve()")
            return
        }
        
        listOfGoals = loadedData
        generateSectionData()
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.SegueToAddDailyGoals {
            let destVC = segue.destination as? AddDailyGoalsController
            destVC?.currentTabIndex = currentTabIndex
            destVC?.delegate = self
        } else if segue.identifier == Const.SegueToEditDailyGoals {
            let destVC = segue.destination as? AddDailyGoalsController
            destVC?.currentTabIndex = currentTabIndex
            destVC?.goals = editGoals
            destVC?.delegate = self
        } else if segue.identifier == Const.SegueToEditWakeUpRoutine {
            print("GO TO EDIT WAKE UP ROUTINE SCREEN")
        } else if segue.identifier == Const.SegueToReport {
            print("GO TO REPORT SCREEN")
        }
    }
    
    @IBAction func segmentedControlOnTapped(_ sender: UISegmentedControl) {
        currentTabIndex = sender.selectedSegmentIndex
        
        if currentTabIndex == Const.TabYesterdayGoals {
            loadData(Const.TabYesterdayGoals)
            if listOfCompletedGoals.count > 0 {
                performSegue(withIdentifier: Const.SegueToReport, sender: self)
            }
        } else if currentTabIndex == Const.TabTodayGoals {
            loadData(Const.TabTodayGoals)
        } else if currentTabIndex == Const.TabTomorrowGoals {
            loadData(Const.TabTomorrowGoals)
        }
    }
    
    func generateSectionData() {
        listOfActiveGoals = [GoalsModel]()
        listOfActiveGoals = listOfGoals.filter {(goals) in
            return goals.statusIdx == Const.GoalsStatusActive
        }
        
        listOfCompletedGoals = [GoalsModel]()
        listOfCompletedGoals = listOfGoals.filter {(goals) in
            return goals.statusIdx == Const.GoalsStatusComplete
        }
    }
}

extension MyDailyGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.currentTabIndex == Const.TabYesterdayGoals {
            if section == 0 {
                return listOfActiveGoals.count == 0 ? 1 : listOfActiveGoals.count
            } else if section == 1 {
                return listOfCompletedGoals.count == 0 ? 1 : listOfCompletedGoals.count
            }
        } else if self.currentTabIndex == Const.TabTodayGoals {
            if section == 0 {
                return 1
            } else if section == 1 {
                return listOfActiveGoals.count == 0 ? 1 : listOfActiveGoals.count
            } else if section == 2 {
                return listOfCompletedGoals.count == 0 ? 1 : listOfCompletedGoals.count
            }
        } else if self.currentTabIndex == Const.TabTomorrowGoals {
            if section == 0 {
                return listOfActiveGoals.count == 0 ? 1 : listOfActiveGoals.count
            }
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.currentTabIndex == Const.TabYesterdayGoals {
            return 2
        } else if self.currentTabIndex == Const.TabTodayGoals {
            return 3
        } else if self.currentTabIndex == Const.TabTomorrowGoals {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableViewCell") as! SectionHeadingTableViewCell
        
        if currentTabIndex == Const.TabYesterdayGoals {
            if section == 0 {
                headerCell.headingLabel.text = "Active Goals"
            } else if section == 1 {
                headerCell.headingLabel.text = "Completed Goals"
            }
        } else if currentTabIndex == Const.TabTodayGoals {
            if section == 0 {
                headerCell.headingLabel.text = "You have a productive day today!"
            } else if section == 1 {
                headerCell.headingLabel.text = "Active Goals"
            } else if section == 2 {
                headerCell.headingLabel.text = "Completed Goals"
            }
        } else if currentTabIndex == Const.TabTomorrowGoals {
            if section == 0 {
                headerCell.headingLabel.text = "Tomorrow Goals"
            }
        }
        
        headerView.addSubview(headerCell)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var goalsData: GoalsModel?
        
        var status: Int = -1
        let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyDataTableViewCell") as! EmptyDataTableViewCell
        
        if currentTabIndex == Const.TabYesterdayGoals {
            if indexPath.section == 0 {
                status = Const.GoalsStatusActive
            } else if indexPath.section == 1 {
                status = Const.GoalsStatusComplete
            }
        } else if currentTabIndex == Const.TabTodayGoals {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodaySummaryTableViewCell") as! TodaySummaryTableViewCell
                cell.dayInRowLabel.text = "0" // HARDCODE DULU GAN
                cell.rateActivitiesLabel.text = "\(listOfCompletedGoals.count) of \(listOfActiveGoals.count + listOfCompletedGoals.count)"
                
                return cell
            } else if indexPath.section == 1 {
                status = Const.GoalsStatusActive
            } else if indexPath.section == 2 {
                status = Const.GoalsStatusComplete
            }
        } else if currentTabIndex == Const.TabTomorrowGoals {
            if indexPath.section == 0 {
                status = Const.GoalsStatusActive
            }
        }
        
        if status == Const.GoalsStatusActive {
            if listOfActiveGoals.count == 0 {
                return emptyCell
            }
            goalsData = listOfActiveGoals[indexPath.row]
        } else if status == Const.GoalsStatusComplete {
            if listOfCompletedGoals.count == 0 {
                return emptyCell
            }
            goalsData = listOfCompletedGoals[indexPath.row]
        }
        
        guard let goalsData = goalsData else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveGoalsTableViewCell") as! ActiveGoalsTableViewCell
        cell.nameLabel.text = goalsData.name
        cell.timeLabel.text = goalsData.getFormattedMinutes()
        cell.priorityLabel.text = Const.MasterGoalsPriority[goalsData.priorityIdx].shortName
        cell.pillsView.backgroundColor = Const.MasterGoalsPriority[goalsData.priorityIdx].color
        if goalsData.statusIdx == Const.GoalsStatusComplete {
            cell.goalsImage.image = Const.GoalsStatusCompletedImage
        } else {
            cell.goalsImage.image = Const.GoalsStatusActiveImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var section = indexPath.section
        if currentTabIndex == Const.TabTodayGoals {
            if indexPath.section == 0 {
                return
            }
            section -= 1
        }
        
        if section == 0 {
            if listOfActiveGoals.count == 0 { return }
            editGoals = listOfActiveGoals[indexPath.row]
        } else if section == 1 {
            if listOfCompletedGoals.count == 0 { return }
            editGoals = listOfCompletedGoals[indexPath.row]
        }
        
        performSegue(withIdentifier: Const.SegueToEditDailyGoals, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var section = indexPath.section
        if currentTabIndex == Const.TabTodayGoals || currentTabIndex == Const.TabTomorrowGoals {
            if indexPath.section == 0 {
                return nil
            }
            section -= 1
        }
        
        if section == 0 {
            if listOfActiveGoals.count == 0 { return nil }
            editGoals = listOfActiveGoals[indexPath.row]
        } else if section == 1 {
            if listOfCompletedGoals.count == 0 { return nil }
            editGoals = listOfCompletedGoals[indexPath.row]
        }
        
        let uploadedAction = UIContextualAction(style: .normal, title: "", handler: {
                (action, sourceView, completionHandler) in
            
            if !self.goalsHolder.update(goalsData: self.editGoals!) {
                print("Something Wrong on goalsHolder.update()")
            }
            
            self.loadData(self.currentTabIndex)

            completionHandler(true)
        })
        
        if editGoals?.statusIdx == Const.GoalsStatusActive {
            uploadedAction.backgroundColor = UIColor(named: "PriorityLowColor")
            editGoals?.statusIdx = Const.GoalsStatusComplete
        } else {
            uploadedAction.backgroundColor = UIColor(named: "PriorityHighColor")
            editGoals?.statusIdx = Const.GoalsStatusActive
        }
        
        uploadedAction.image = UIImage(systemName: "flag.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var section = indexPath.section
        if currentTabIndex == Const.TabTodayGoals {
            if indexPath.section == 0 {
                return nil
            }
            section -= 1
        }
        
        if section == 0 {
            if listOfActiveGoals.count == 0 { return nil }
            editGoals = listOfActiveGoals[indexPath.row]
        } else if section == 1 {
            if listOfCompletedGoals.count == 0 { return nil }
            editGoals = listOfCompletedGoals[indexPath.row]
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "") {
            (action, sourceView, completionHandler) in
            if !self.goalsHolder.delete(goalsData: self.editGoals!) {
                print("Something Wrong on goalsHolder.delete()")
            }
            
            self.loadData(self.currentTabIndex)

            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Delete should not delete automatically
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}

extension MyDailyGoalsViewController: AddDailyGoalsControllerDelegate {
    func reloadTableData(currentTabIndex: Int) {
        loadData(currentTabIndex)
        self.currentTabIndex = currentTabIndex
    }
}
