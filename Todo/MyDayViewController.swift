//
//  MyDayViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class MyDayViewController: UIViewController, UITextFieldDelegate {
    
    var taskStore: TaskStore!

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var addTaskField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addTask(_ sender: UIButton){
        let newTask = taskStore.createTask(name: addTaskField.text)
        var indexPath = IndexPath()

        if let index = taskStore.unfinishedTask.firstIndex(of: newTask){
            indexPath = IndexPath(row: index, section: 0)
        }
        taskTable.insertRows(at: [indexPath], with: .automatic)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
extension MyDayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return taskStore.unfinishedTask.count
        }
        else{
            return taskStore.finishedTask.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        if indexPath.section == 0{
            cell.createCell(name: taskStore.unfinishedTask[indexPath.row].name)
            cell.task = taskStore.unfinishedTask[indexPath.row]
        }
        else{
            cell.createCell(name: taskStore.finishedTask[indexPath.row].name)
            cell.task = taskStore.finishedTask[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "My Day"
        }
        else{
            return "Finished"
        }
    }
}

// MARK: - TaskTableViewCellDelegate
extension MyDayViewController: TaskTableViewCellDelegate{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task, didTapFinishButtonWithState state: Bool) {
        for tmpTask in taskStore.unfinishedTask {
            if tmpTask.id == task.id{
                if let index = taskStore.unfinishedTask.firstIndex(of: task){
                    taskStore.unfinishedTask.remove(at: index)
                    taskStore.finishedTask.append(task)
                }
            }
        }
        task.isFinished = state
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task, didTapImportantButtonWithState state: Bool) {
        for tmpTask in taskStore.allTask {
            if tmpTask == task{
                taskStore.importantTask.append(task)
            }
        }
        task.isImportant = state
    }
}


