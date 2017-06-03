//
//  ProjectsTableViewController.swift
//  Project_Manager_Single_View_Start
//
//  Created by David Kooistra on 5/30/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreData

var selectedTitle: String?
var selectedRow: Int?

class ProjectsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //var myProjects = [["title":"Build This Cool App", "image": "coffee", "detail":"Just For Fun"], ["title":"Organize Desk", "image": "desk", "detail":"To Simplify Life"]]
    
    var projects = [Project]()
    
    
    
    
    var updatedProgress: Int16!
    
    var managedObjectContext:NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.navigationItem.setHidesBackButton(true, animated:true)
        let iconImageView = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = iconImageView
        tableView.tableFooterView = UIView()
        
        updateProgress()
        
        loadData()
    }
    
    func loadData() {
        //Get all of the project items stored in the database
        let projectRequest:NSFetchRequest<Project> = Project.fetchRequest()
        
        // Here we can edit the loaded data
        // i.e. projectRequest.sortDescriptors
        
        do {
            projects = try managedObjectContext.fetch(projectRequest)
            self.tableView.reloadData()
        } catch {
            print("Unable to load data \(error.localizedDescription)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProjectDetailsTableViewCell

        let projectObject = projects[indexPath.row]
        
        
        if let projectImage = UIImage(data: projectObject.image! as Data) {
            cell.backgroundImageView.image = projectImage
        }
 
        cell.projectTitle.text = projectObject.title
        cell.extraInfo.text = projectObject.details
        cell.projectProgressLabel.text = "\(projectObject.progress)%"
        
        cell.selectionStyle = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        selectedRow = indexPath.row
        selectedTitle = projects[indexPath.row].title
        performSegue(withIdentifier: "toTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // push the task view controller to a variable
        let destNavigationController = segue.destination as! UINavigationController
        let targetController = destNavigationController.topViewController as! ProjectTasksViewController
        targetController.projectTitleFromMain = projects[selectedRow!].title
        targetController.imageBackgroundFromMain = UIImage(data: projects[selectedRow!].image! as Data, scale: 1.0)
        targetController.selectedTitle = projects[selectedRow!].title
        targetController.projectProgress = projects[selectedRow!].progress
        targetController.selectedRowFromMain = selectedRow!
    }
    
    @IBAction func addProject(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createProjectObject(with: image)
            })
        }
    }

 
    func createProjectObject (with image:UIImage) {
 
        let projectItem = Project(context: managedObjectContext)
 
        projectItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
 
        let inputAlert = UIAlertController(title: "New Project", message: "Enter a project name and purpose", preferredStyle: .alert)
        
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Project Name"
        }
        inputAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Purpose"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let projectTextField = inputAlert.textFields?.first
            let purposeTextField = inputAlert.textFields?.last
            
            if (projectTextField?.text != "" && purposeTextField?.text != "") {
                projectItem.title = projectTextField?.text
                projectItem.details = purposeTextField?.text
                projectItem.progress = 0
                
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                } catch {
                    print("Could not save data: \(error.localizedDescription)")
                }
            }
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
        
        print("Progress: \(projectItem.progress)")
        
    }
    
    
    func updateProgress() {
        print("UP FUNCTION:")
        let projectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        do{
            let results = try managedObjectContext.fetch(projectRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let title = result.value(forKey: "title") as? String {
                        if title == selectedTitle {
                            result.setValue(updatedProgress, forKey: "progress")
                            
                            do {
                                try managedObjectContext.save()
                            } catch {
                                
                            }
                        }
                        print(title)
                    }
                    print(result.value(forKey: "progress")!)
                }
            }
        } catch {
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // VVV  TEMPLATE CODE BELOW  VVV
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteProject(projectName: projects[indexPath.row].title!, row: indexPath.row)
            
            /*
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            projects.remove(at: indexPath.row)
            
            // delete item from core data
            //Get all of the project items stored in the database
            let projectRequest:NSFetchRequest<Project> = Project.fetchRequest()
            
            let result = try? managedObjectContext.fetch(projectRequest)
            
            var resultData = result!
            
            managedObjectContext.delete(resultData[indexPath.row])
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Unable to save projects after delete")
            }
            
            // Here we can edit the loaded data
            
            do {
                projects = try managedObjectContext.fetch(projectRequest)
                self.tableView.reloadData()
            } catch {
                print("Unable to load data \(error.localizedDescription)")
            }
 */
            
        }
        /*
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }  
         */
    }
    
    
    // Deletes the project and associated tasks from core data (and local projects array)
    func deleteProject(projectName: String, row: Int){
        // Remove corresponding tasks from core data
        let taskRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let taskResults = try managedObjectContext.fetch(taskRequest) // tasks
            
            if taskResults.count > 0 {
                for taskResult in taskResults as! [NSManagedObject] {
                    if let taskOwner = taskResult.value(forKey: "selectedTitle") as? String{
                        if taskOwner == projects[row].title {
                            managedObjectContext.delete(taskResult)
                        }
                    }
                }
            }
            
        } catch {
            print ("Error: unable to load tasks for delete in main projects VC")
        }
        
        do {
            try managedObjectContext.save()
            print("Saved context - after delete tasks from deleting project")
        } catch {
            print("Error: could not save tasks with deleted tasks for deleted project")
        }

        
        
        // Remove project from core data
        let projectRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        do {
            let projectResults = try managedObjectContext.fetch(projectRequest) // projects
            
            if projectResults.count > 0 {
                for projectResult in projectResults as! [NSManagedObject] {
                    if let projectName = projectResult.value(forKey: "title") as? String{
                        if projectName == projects[row].title {
                            managedObjectContext.delete(projectResult)
                        }
                    }
                }
            }
        } catch {
            
        }
        
        do {
            try managedObjectContext.save()
            print("Saved context - after delete project")
        } catch {
            print("Error: could not save project after delete project")
        }
        
        // Remove project from local array
        projects.remove(at: row)
        
        self.tableView.reloadData()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
