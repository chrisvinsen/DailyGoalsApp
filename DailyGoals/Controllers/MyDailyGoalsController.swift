//
//  ViewController.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 27/04/22.
//

import UIKit

class MyDailyGoalsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listOfGoals = [Goals]() // Used on table view
    var listOfActiveGoals = [Goals]()
    var listOfCompletedGoals = [Goals]()
    
    var currentTabIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seedDummyTodayData() // need to delete this later
        generateSectionData()
        
        // Register NIB for table cells
        tableView.register(UINib(nibName: "TodaySummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "TodaySummaryTableViewCell")
        tableView.register(UINib(nibName: "ActiveGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveGoalsTableViewCell")
        tableView.register(UINib(nibName: "SectionHeadingTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableViewCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.SegueToAddDailyGoals {
            let destVC = segue.destination as? AddDailyGoalsController
//            destVC?.currentTabIndex = 1
            destVC?.delegate = self
        } else if segue.identifier == Const.SegueToEditDailyGoals {
            let destVC = segue.destination as? AddDailyGoalsController
//            destVC?.currentTabIndex = 2
            destVC?.goals = Goals(name: "test", minutes: 75, priorityIdx: 2, statusIdx: 1)
            destVC?.delegate = self
        } else if segue.identifier == Const.SegueToEditWakeUpRoutine {
            print("WILL DO IT LATER")
        } else if segue.identifier == Const.SegueToReport {
//            let destVC = segue.destination as? ReportViewController
//            navigationController?.visibleViewController?.navigationItem.title = "My Daily Goals"
            
            print("TO REPORT")
        }
    }
    
    @IBAction func segmentedControlOnTapped(_ sender: UISegmentedControl) {
        currentTabIndex = sender.selectedSegmentIndex
        
        if currentTabIndex == Const.TabYesterdayGoals {
            seedDummyYesterdayData()
            generateSectionData()
            tableView.reloadData()
            performSegue(withIdentifier: Const.SegueToReport, sender: self)
        } else if currentTabIndex == Const.TabTodayGoals {
            seedDummyTodayData()
            generateSectionData()
            tableView.reloadData()
        } else if currentTabIndex == Const.TabTomorrowGoals {
            seedDummyTomorrowData()
            generateSectionData()
            tableView.reloadData()
        }
    }
    
    func generateSectionData() {
        listOfActiveGoals = [Goals]()
        listOfActiveGoals = listOfGoals.filter {(goals) in
            return goals.statusIdx == 0
        }
        
        listOfCompletedGoals = [Goals]()
        listOfCompletedGoals = listOfGoals.filter {(goals) in
            return goals.statusIdx == 1
        }
    }
}

extension MyDailyGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.currentTabIndex == Const.TabYesterdayGoals {
            if section == 0 {
                return listOfActiveGoals.count
            } else if section == 1 {
                return listOfCompletedGoals.count
            }
        } else if self.currentTabIndex == Const.TabTodayGoals {
            if section == 0 {
                return 1
            } else if section == 1 {
                return listOfActiveGoals.count
            } else if section == 2 {
                return listOfCompletedGoals.count
            }
        } else if self.currentTabIndex == Const.TabTomorrowGoals {
            if section == 0 {
                return listOfActiveGoals.count
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
                headerCell.headingLabel.text = "Active Goals"
            }
        }
        
        headerView.addSubview(headerCell)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var goalsData: Goals?
        
        if currentTabIndex == Const.TabYesterdayGoals {
            if indexPath.section == 0 {
                goalsData = listOfActiveGoals[indexPath.row]
            } else if indexPath.section == 1 {
                goalsData = listOfCompletedGoals[indexPath.row]
            }
        } else if currentTabIndex == Const.TabTodayGoals {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodaySummaryTableViewCell") as! TodaySummaryTableViewCell
                
                return cell
            } else if indexPath.section == 1 {
                goalsData = listOfActiveGoals[indexPath.row]
            } else if indexPath.section == 2 {
                goalsData = listOfCompletedGoals[indexPath.row]
            }
        } else if currentTabIndex == Const.TabTomorrowGoals {
            if indexPath.section == 0 {
                goalsData = listOfActiveGoals[indexPath.row]
            }
        }
        
        guard let goalsData = goalsData else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveGoalsTableViewCell") as! ActiveGoalsTableViewCell
        cell.nameLabel.text = goalsData.name
        cell.timeLabel.text = goalsData.getFormattedMinutes()
        cell.priorityLabel.text = Const.MasterGoalsPriority[goalsData.priorityIdx].shortName
        cell.pillsView.backgroundColor = Const.MasterGoalsPriority[goalsData.priorityIdx].color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            performSegue(withIdentifier: Const.SegueToEditDailyGoals, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uploadedAction = UIContextualAction(style: .normal, title: "", handler: {
                (action, sourceView, completionHandler) in
            
            print("test")
//            self.swipeUploadedFlagAction(book: book)
//
//            completionHandler(true)
        })
        
        uploadedAction.backgroundColor = UIColor(named: "PrimaryColor")
        uploadedAction.image = UIImage(systemName: "flag.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "") {
            (action, sourceView, completionHandler) in
            print("DELETE")
//            let book = self.books[(indexPath as NSIndexPath).row] as Book
            // Delete the book and associated records
//            self.swipeDeleteAction(book: book, indexPath: indexPath)
            // Remove the menu option from the screen
//            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        // Delete should not delete automatically
//        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}

extension MyDailyGoalsViewController: AddDailyGoalsControllerDelegate {
    func reloadTableData(currentTabIndex: Int) {
        generateSectionData()
        
        if currentTabIndex == Const.TabYesterdayGoals {
            // Reload Yesterday Data
            tableView.reloadData()
        } else if currentTabIndex == Const.TabTodayGoals {
            // Reload Today Data
            tableView.reloadData()
        } else if currentTabIndex == Const.TabTomorrowGoals {
            // Reload Tomorrow Data
            tableView.reloadData()
        }
        
        self.currentTabIndex = currentTabIndex
    }
}



extension MyDailyGoalsViewController {
    func seedDummyTodayData() {
        listOfGoals = [Goals]()
        listOfGoals.append(Goals(name: "Makan", minutes: 300, priorityIdx: 2, statusIdx: 0))
        listOfGoals.append(Goals(name: "Tidur", minutes: 300, priorityIdx: 1, statusIdx: 0))
        listOfGoals.append(Goals(name: "Baca Buku", minutes: 75, priorityIdx: 0, statusIdx: 0))
        listOfGoals.append(Goals(name: "Makan nih", minutes: 30, priorityIdx: 2, statusIdx: 1))
        listOfGoals.append(Goals(name: "Makan", minutes: 300, priorityIdx: 2, statusIdx: 0))
        listOfGoals.append(Goals(name: "Tidur", minutes: 300, priorityIdx: 1, statusIdx: 0))
        listOfGoals.append(Goals(name: "Baca Buku", minutes: 75, priorityIdx: 0, statusIdx: 0))
        listOfGoals.append(Goals(name: "Makan nih", minutes: 30, priorityIdx: 2, statusIdx: 1))
    }
    
    func seedDummyYesterdayData() {
        listOfGoals = [Goals]()
        listOfGoals.append(Goals(name: "Minum", minutes: 150, priorityIdx: 1, statusIdx: 0))
        listOfGoals.append(Goals(name: "Bobo Ganteng", minutes: 75, priorityIdx: 2, statusIdx: 1))
        listOfGoals.append(Goals(name: "Makan", minutes: 200, priorityIdx: 0, statusIdx: 0))
        listOfGoals.append(Goals(name: "Minum", minutes: 150, priorityIdx: 1, statusIdx: 0))
        listOfGoals.append(Goals(name: "Bobo Ganteng", minutes: 75, priorityIdx: 2, statusIdx: 1))
    }
    
    func seedDummyTomorrowData() {
        listOfGoals = [Goals]()
        listOfGoals.append(Goals(name: "Ngoding aja deh", minutes: 250, priorityIdx: 0, statusIdx: 0))
        listOfGoals.append(Goals(name: "Tidur", minutes: 50, priorityIdx: 1, statusIdx: 0))
        listOfGoals.append(Goals(name: "Makan nih", minutes: 90, priorityIdx: 2, statusIdx: 1))
        listOfGoals.append(Goals(name: "Ngoding aja deh", minutes: 250, priorityIdx: 0, statusIdx: 0))
        listOfGoals.append(Goals(name: "Tidur", minutes: 50, priorityIdx: 1, statusIdx: 0))
    }
}
