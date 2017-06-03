//
//  ProjectTasksViewController.swift
//  Project_Manager_Single_View_Start
//
//  Created by David Kooistra on 6/1/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreData

class ProjectTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedTitle: String! //Project title
    var selectedTasks = [Task]()
    var projectProgress: Int16!
    var selectedRowFromMain: Int!
    var selectedTask: Task! //Passing info to task notes
    var updatedNotes: String!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var viewWithSlider: UIView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBAction func sliderMoved(_ sender: Any) {
        progressLabel.text = "Progress: \(Int(slider.value * 100))%"
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    
    @IBAction func addTaskPressed(_ sender: Any) {
        createTaskObject()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext:NSManagedObjectContext!

    var tasks = [Task]()
    
    var projectTitleFromMain: String!
    var imageBackgroundFromMain: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.title = projectTitleFromMain
        self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil
        selectedTitle = projectTitleFromMain
        // hide unused cells
        tableView.tableFooterView = UIView()
        imageBackground.image = imageBackgroundFromMain
        viewWithSlider.backgroundColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 0.9)
        
        // Progress label
        slider.value = Float(projectProgress)/100.0
        progressLabel.text = "Progress: \(Int(slider.value * 100))%"
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
        return selectedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")
        cell?.textLabel?.text = selectedTasks[indexPath.row].taskName
        cell?.textLabel?.textColor = UIColor.white
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // MARK: - Functionality
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "toTaskNotes", sender: self)
    }
    
    func createTaskObject () {
        
        let taskItem = Task(context: managedObjectContext)
        
        let inputAlert = UIAlertController(title: "New Task", message: "Enter a task name", preferredStyle: .alert)
        
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Task name"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let taskTextField = inputAlert.textFields?.first
            
            if (taskTextField?.text != "") {
                taskItem.taskName = taskTextField?.text
                taskItem.selectedTitle = self.selectedTitle
                taskItem.notes = ""
                
                do {
                    try self.managedObjectContext.save()
                    self.selectedTasks.append(taskItem)
                    self.loadData()
                } catch {
                    print("Could not save data: \(error.localizedDescription)")
                }
            }
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
        
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let selectedTask = selectedTasks[indexPath.row]
            // selectedTasks.remove(at: indexPath.row)
            var counter : Int = 0
            for task in tasks {
                if task.selectedTitle == selectedTask.selectedTitle && task.taskName == selectedTask.taskName {
                    // tasks.remove(at: counter)
                    // remove task from the result when fetching
                    break
                }
                counter += 1
            }
            
            // delete item from core data
            //Get all of the project items stored in the database
            let taskRequest:NSFetchRequest<Task> = Task.fetchRequest()
            
            let result = try? managedObjectContext.fetch(taskRequest)
            
            var resultData = result!
            
            managedObjectContext.delete(resultData[counter])
            
            do {
                try managedObjectContext.save()
                loadData()
            } catch {
                print("Unable to save tasks after delete")
            }
            
            // Here we can edit the loaded data
            
            do {
                tasks = try managedObjectContext.fetch(taskRequest)
                self.tableView.reloadData()
            } catch {
                print("Unable to load task data \(error.localizedDescription)")
            }
            
        }
        /*
         else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         */
    }

    
    // MARK: - Core Data
    
    func loadData() {
        //Get all of the project items stored in the database
        let taskRequest:NSFetchRequest<Task> = Task.fetchRequest()
        
        // Here we can edit the loaded data
        // i.e. projectRequest.sortDescriptors
        
        do {
            tasks = try managedObjectContext.fetch(taskRequest)
            selectedTasks.removeAll()
            for task in tasks {
                if task.selectedTitle == selectedTitle {
                    selectedTasks.append(task)
                }
            }
            self.tableView.reloadData()
        } catch {
            print("Unable to load data \(error.localizedDescription)")
        }
    }
 
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMain" {
            // push the task view controller to a variable
            let targetController = segue.destination as! ProjectsTableViewController
            targetController.updatedProgress = (Int16(slider.value * 100))
        }
        else if segue.identifier == "toTaskNotes" {
            let targetController = segue.destination as! TaskNotesViewController
            targetController.selectedTask = selectedTask
        }
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
