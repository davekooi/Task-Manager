//
//  ProjectTasksViewController.swift
//  Project_Manager_Single_View_Start
//
//  Created by David Kooistra on 6/1/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ProjectTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var numbers = ["1", "2", "3"]
    
    var projectTitleFromMain: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.title = projectTitleFromMain
        self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setting the Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
        cell?.textLabel?.text = numbers[indexPath.row]
        cell?.textLabel?.textColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
