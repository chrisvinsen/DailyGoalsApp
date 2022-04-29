//
//  ReportViewController.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listOfGoals = [GoalsModel]() // Used on table view
    var listOfActiveGoals = [GoalsModel]()
    var listOfCompletedGoals = [GoalsModel]()
    
    let goalsHolder = GoalsHolder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Yesterday Report"
        
        loadYesterdayData()
        
        // Register NIB for table cells
        tableView.register(UINib(nibName: "YesterdaySummaryOneTableViewCell", bundle: nil), forCellReuseIdentifier: "YesterdaySummaryOneTableViewCell")
        tableView.register(UINib(nibName: "YesterdaySummaryTwoTableViewCell", bundle: nil), forCellReuseIdentifier: "YesterdaySummaryTwoTableViewCell")
        tableView.register(UINib(nibName: "ActiveGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveGoalsTableViewCell")
        tableView.register(UINib(nibName: "SectionHeadingWithSubHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingWithSubHeadingTableViewCell")
    }
    
    func loadYesterdayData() {
        var startDateTime: Date
        var endDateTime: Date
        
        let todayDate = Date()
        let day = todayDate.get(.day)
        let month = todayDate.get(.month)
        let year = todayDate.get(.year)
        
        startDateTime = Helper.stringToDateTime("\(month)/\(day - 1)/\(year) 00:00:00")
        endDateTime = Helper.stringToDateTime("\(month)/\(day - 1)/\(year) 23:59:59")
        
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

    @IBAction func continueButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        } else if section == 1 {
            return listOfCompletedGoals.count
        } else if section == 2 {
            return listOfActiveGoals.count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingWithSubHeadingTableViewCell") as! SectionHeadingWithSubHeadingTableViewCell

        if section == 0 {
            headerCell.headingLabel.text = "Congratulation !!"
            headerCell.subHeadingLabel.text = "You were very productive yesterday"
        } else if section == 1 {
            headerCell.headingLabel.text = "Great !"
            headerCell.subHeadingLabel.text = "You have done these"
        } else if section == 2 {
            if listOfActiveGoals.count == 0 {
                return nil
            }
            headerCell.headingLabel.text = "But ..."
            headerCell.subHeadingLabel.text = "You have missed these"
        }
        
        headerView.addSubview(headerCell)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var goalsData: GoalsModel?
        
        var status: Int = -1
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YesterdaySummaryOneTableViewCell") as! YesterdaySummaryOneTableViewCell
                cell.rateActivitiesLabel.text = "\(listOfCompletedGoals.count) of \(listOfActiveGoals.count + listOfCompletedGoals.count)"
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "YesterdaySummaryTwoTableViewCell") as! YesterdaySummaryTwoTableViewCell
                
                var totalMinutes = 0
                var totalHigh = 0
                var totalMed = 0
                var totalLow = 0
                
                for completedGoals in listOfCompletedGoals {
                    totalMinutes += completedGoals.minutes
                    switch completedGoals.priorityIdx {
                    case Const.GoalsPriorityLow:
                        totalLow += 1
                    case Const.GoalsPriorityMed:
                        totalMed += 1
                    case Const.GoalsPriorityHigh:
                        totalHigh += 1
                    default:
                        print("Invalid Priority Status")
                    }
                }
                
                cell.hoursLabel.text = "\(totalMinutes / 60) Hours"
                cell.minutesLabel.text = "\(totalMinutes % 60) Minutes"
                cell.highLabel.text = "\(totalHigh) High"
                cell.medLabel.text = "\(totalMed) Med"
                cell.lowLabel.text = "\(totalLow) Low"
                
                return cell
            }
        } else if indexPath.section == 1 {
            status = Const.GoalsStatusComplete
        } else if indexPath.section == 2 {
            status = Const.GoalsStatusActive
        }
        
        if status == Const.GoalsStatusActive {
            goalsData = listOfActiveGoals[indexPath.row]
        } else if status == Const.GoalsStatusComplete {
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
}
