//
//  PlannedViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class PlannedViewController: UIViewController, UITextFieldDelegate {
    
    var taskStore: TaskStore!

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var addTaskField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addTask(_ sender: UIButton){
        if let taskName = addTaskField.text, !taskName.isEmpty{
            let newTask = taskStore.createTask(name: addTaskField.text, type: .planned)
            var indexPath = IndexPath()
            if let index = taskStore.plannedTask.lastIndex(of: newTask){
                indexPath = IndexPath(row: index, section: 0)
            }
            taskTable.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskTable.delegate = self
        taskTable.dataSource = self
        self.taskTable.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        
        taskTable.rowHeight = 60
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlannedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.plannedTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.task = taskStore.plannedTask[indexPath.row]
        cell.createCell(name: taskStore.plannedTask[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Planned"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - TaskTableViewCellDelegate
extension PlannedViewController: TaskTableViewCellDelegate{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task) {
        task.isFinished = true
        taskTable.reloadSections([0], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task) {
        let state = task.isImportant
        if state == false{
            for tmpTask in taskStore.allTask {
                if tmpTask.id == task.id{
                    task.isImportant = true
                }
            }
        }
        else{
            for tmpTask in taskStore.allTask {
                if tmpTask.id == task.id{
                    task.isImportant = false
                }
            }
        }
        taskTable.reloadSections([0], with: .automatic)
    }
}


