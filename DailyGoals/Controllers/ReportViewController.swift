//
//  ReportViewController.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import UIKit

class ReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Yesterday Report"
        
//        let rightBarButtonItem = UIBarButtonItem(
//            title: "Save",
//            style: .plain,
//            target: self,
//            action: #selector(btnSaveOnClicked)
//        )
//        rightBarButtonItem.tintColor = #colorLiteral(red: 0.05490196078, green: 0.662745098, blue: 0.3450980392, alpha: 1)
//        navigationItem.rightBarButtonItem = rightBarButtonItem
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
