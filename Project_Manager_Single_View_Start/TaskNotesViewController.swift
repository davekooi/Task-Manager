//
//  TaskNotesViewController.swift
//  Project_Manager_Single_View_Start
//
//  Created by David Kooistra on 6/2/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreData

/*
// Pass updated notes to the tasks view controller to save that notes for that specific task
extension TaskNotesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        print("Pressed back from notes to tasks")
        saveNotesForTask()
    }
}
 */

class TaskNotesViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var selectedTask: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedTask.taskName
        if selectedTask.notes == "" {
            textView.text = "Insert and edit notes here"
        }
        else {
            textView.text = selectedTask.notes
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Save notes to corresponding task when leaving the note page
    override func viewDidDisappear(_ animated: Bool) {
        saveNotesForTask()
    }
    
    // MARK: - Core Data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveNotesForTask() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let taskName = result.value(forKey: "taskName") as? String{
                        if let projectName = result.value(forKey: "selectedTitle") as? String {
                            if (taskName == selectedTask.taskName && projectName == selectedTask.selectedTitle) {
                                result.setValue(textView.text, forKey: "notes")
                                
                                do {
                                    try context.save()
                                    print("Saved context - notes to task")
                                } catch {
                                    print("Error: could not save notes to task")
                                }
                            
                                break
                            }
                        }
                    }
                }
            }
            
        } catch {
            print ("Error: unable to load tasks")
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
