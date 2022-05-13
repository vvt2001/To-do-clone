//
//  TaskModificationViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class TaskModificationViewController: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var optionTable: UITableView!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var addStep: UIButton!
    @IBOutlet weak var stepNameField: UITextField!
    
    var task: Task!
    var delegate: TaskModificationViewControllerDelegate?
    
    @IBAction func changeTaskName(_ sender: UITextField){
        if let taskName = taskNameField.text, !taskName.isEmpty{
            task.name = taskName
            delegate?.taskModificationViewController?(self)
        }
    }

    @IBAction func changeFinished(_ sender: UIButton){
        if !task.isFinished{
            task.isFinished = true
            self.finishedButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            print("\(task.isFinished)")
        }
        else{
            task.isFinished = false
            self.finishedButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            print("\(task.isFinished)")
        }
        delegate?.taskModificationViewController?(self)

    }
    @IBAction func changeImportant(_ sender: UIButton){
        if !task.isImportant{
            task.isImportant = true
            self.importantButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            print("\(task.isImportant)")
        }
        else{
            task.isImportant = false
            self.importantButton.setImage(UIImage(systemName: "star"), for: .normal)
            print("\(task.isImportant)")
        }
        delegate?.taskModificationViewController?(self)

    }
    @IBAction func addStep(_ sender: UIButton){
        if let stepName = stepNameField.text, !stepName.isEmpty{
            let step = Step(name: stepName)
            task.createStep(name: stepName)
            var indexPath = IndexPath()
            if let index = task.steps.lastIndex(of: step){
                indexPath = IndexPath(row: index, section: 0)
            }
            optionTable.insertRows(at: [indexPath], with: .automatic)
            stepNameField.text = .none
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskNameField.text = task.name
        if task.isFinished{
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else{
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        if task.isImportant{
            self.importantButton.imageView?.image = UIImage(systemName: "star.fill")
        }
        else{
            self.importantButton.imageView?.image = UIImage(systemName: "star")
        }
        
        optionTable.delegate = self
        optionTable.dataSource = self
        self.optionTable.register(UINib(nibName: "TaskStepTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskStepTableViewCell")
        self.optionTable.register(UINib(nibName: "ModifyOptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ModifyOptionTableViewCell")
        
        optionTable.rowHeight = 50
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

extension TaskModificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return task.steps.count
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepCell = optionTable.dequeueReusableCell(withIdentifier: "TaskStepTableViewCell", for: indexPath) as! TaskStepTableViewCell
        let optionCell = optionTable.dequeueReusableCell(withIdentifier: "ModifyOptionTableViewCell", for: indexPath) as! ModifyOptionTableViewCell
        if indexPath.section == 0 {
            stepCell.delegate = self
            stepCell.task = task
            stepCell.createCell(task: task, index: indexPath)
            return stepCell
        }
        else{
            optionCell.createCell(task: task, index: indexPath.row)
            return optionCell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "step"
        }
        else {
            return "option"
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            switch indexPath.row{
            case 0:
                if task.isMyDay{
                    task.isMyDay = false
                }
                else{
                    task.isMyDay = true
                }
                optionTable.reloadData()
            case 2:
                if task.dueDate == nil{
                    let dueViewController = DueViewController()
                    dueViewController.delegate = self
                    present(dueViewController, animated: true, completion: nil)
                }
                else{
                    task.dueDate = .none
                }
                optionTable.reloadData()
            default:
                break
            }
        }
    }
}

extension TaskModificationViewController: TaskStepTableViewCellDelegate{
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell, didSelectDeleteAtIndexPath indexPath: IndexPath) {
        task.deleteStep(index: indexPath.row)
        optionTable.deleteRows(at: [indexPath], with: .automatic)
        
    }
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell) {
        optionTable.reloadSections([0], with: .automatic)
    }
}

// MARK: - DueViewControllerDelegate
extension TaskModificationViewController: DueViewControllerDelegate{
    func dueViewController(_ viewController: UIViewController, didTapAtIndex index: Int, dateForIndex date: Date?){
        task.dueDate = date
        delegate?.taskModificationViewController?(self, didTapAddDueDateWithDue: date, didTapAddDueDateWithIndex: index)
        optionTable.reloadData()
    }
}

@objc protocol TaskModificationViewControllerDelegate{
    @objc optional func taskModificationViewController(_ viewController: UIViewController, didTapAddDueDateWithDue due: Date?, didTapAddDueDateWithIndex index: Int)
    @objc optional func taskModificationViewController(_ viewController: UIViewController)
}
