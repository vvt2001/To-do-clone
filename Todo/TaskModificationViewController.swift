//
//  TaskModificationViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class TaskModificationViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var optionTable: UITableView!
    @IBOutlet weak private var finishedButton: UIButton!
    @IBOutlet weak private var importantButton: UIButton!
    @IBOutlet weak private var taskNameField: UITextField!
    @IBOutlet weak private var dateCreatedLabel: UILabel!
    @IBOutlet weak private var addStep: UIButton!
    @IBOutlet weak private var stepNameField: UITextField!
    
    var task: Task!
    var delegate: TaskModificationViewControllerDelegate?
    
    @IBAction private func changeTaskName(_ sender: UITextField){
        if let taskName = taskNameField.text, !taskName.isEmpty{
            task.setName(name: taskName)
            self.navigationItem.title = taskName
            delegate?.taskModificationViewControllerDidChangeTask?(self)
        }
    }

    @IBAction private func changeFinished(_ sender: UIButton){
        if !task.getIsFinished(){
            task.setIsFinished(isFinished: true)
            self.finishedButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else{
            task.setIsFinished(isFinished: false)
            self.finishedButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        delegate?.taskModificationViewControllerDidChangeTask?(self)

    }
    @IBAction private func changeImportant(_ sender: UIButton){
        if !task.getIsImportant(){
            task.setIsImportant(isImportant: true)
            self.importantButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            print("\(task.getIsImportant())")
        }
        else{
            task.setIsImportant(isImportant: false)
            self.importantButton.setImage(UIImage(systemName: "star"), for: .normal)
            print("\(task.getIsImportant())")
        }
        delegate?.taskModificationViewControllerDidChangeTask?(self)

    }
    @IBAction private func addStep(_ sender: UIButton){
        if let stepName = stepNameField.text, !stepName.isEmpty{
            let newStep = Step(name: stepName, taskID: task.getId())
            task.createStep(step: newStep)
            var indexPath = IndexPath()
            if let index = task.steps.lastIndex(of: newStep){
                indexPath = IndexPath(row: index, section: 0)
            }
            optionTable.insertRows(at: [indexPath], with: .automatic)
            stepNameField.text = .none
        }
    }
    
    @IBAction private func deleteTask(_ sender: UIButton) {
        delegate?.taskModificationViewController?(self, didTapDeleteWithTask: task)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskNameField.text = task.getName()
        if task.getIsFinished(){
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else{
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        if task.getIsImportant(){
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
        
        self.title = task.getName()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        dateCreatedLabel.text = "Created " +  task.getCreateDate().date
    }
    
    private func presentDueViewController(){
        let dueViewController = DueViewController()
        dueViewController.transitioningDelegate = self
        dueViewController.modalTransitionStyle = .coverVertical
        dueViewController.modalPresentationStyle = .custom
        dueViewController.delegate = self
        self.view.layer.opacity = 0.5
        self.present(dueViewController, animated: true, completion: nil)
    }
    
    private func presentNoteViewController(){
        let noteViewController = NoteViewController()
        noteViewController.task = task
        noteViewController.delegate = self
        self.present(noteViewController, animated: true, completion: nil)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    private func requestNotification(task: Task){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Task Management", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "'\(task.getName())' is about to meets due. Make sure to finish it.", arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var remindDate = Date()
        if let dueDate = task.getDueDate() {
            remindDate = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: dueDate)!
        }
        else{
            remindDate = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
        }
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var remindDateComponent = DateComponents()
        remindDateComponent.day = calendar.component(.day, from: remindDate)
        remindDateComponent.month = calendar.component(.month, from: remindDate)
        remindDateComponent.year = calendar.component(.year, from: remindDate)
        remindDateComponent.hour = calendar.component(.hour, from: remindDate)
        remindDateComponent.minute = calendar.component(.minute, from: remindDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: remindDateComponent, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let identifier = UUID().uuidString
        task.setRemindId(remindId: identifier)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func removeNotification(task: Task){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.getRemindId()])
        task.setRemindId(remindId: "")
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
extension TaskModificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return task.steps.count
        }
        else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepCell = optionTable.dequeueReusableCell(withIdentifier: "TaskStepTableViewCell", for: indexPath) as! TaskStepTableViewCell
        let optionCell = optionTable.dequeueReusableCell(withIdentifier: "ModifyOptionTableViewCell", for: indexPath) as! ModifyOptionTableViewCell
        if indexPath.section == 0 {
            stepCell.delegate = self
            stepCell.task = task
            stepCell.step = task.steps[indexPath.row]
            stepCell.createCell(task: task, indexPath: indexPath)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            switch indexPath.row{
            case 0:
                if task.getIsMyDay(){
                    task.setIsMyDay(isMyDay: false)
                }
                else{
                    task.setIsMyDay(isMyDay: true)
                }
            case 1:
                if task.getRemindId() != ""{
                    removeNotification(task: task)
                }
                else{
                    requestNotification(task: task)
                }
            case 2:
                if task.getDueDate() == nil{
                    presentDueViewController()
                }
                else{
                    task.setDueDate(dueDate: nil)
                }
            case 3:
                presentNoteViewController()
            default:
                break
            }
            optionTable.reloadData()
        }
    }
}

extension TaskModificationViewController: TaskStepTableViewCellDelegate{
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell, didSelectDeleteWithStep step: Step, didSelectDeleteAtIndexPath indexPath: IndexPath) {
        task.deleteStep(step: step)
        optionTable.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell) {
        optionTable.reloadSections([0], with: .automatic)
    }
}

// MARK: - DueViewControllerDelegate
extension TaskModificationViewController: DueViewControllerDelegate{
    func dueViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.optionTable.reloadData()
    }
    
    func dueViewController(_ viewController: UIViewController, didTapAtIndex index: Int, dateForIndex date: Date?){
        task.setDueDate(dueDate: date)
        delegate?.taskModificationViewController?(self, didTapAddDueDateWithDue: date, didTapAddDueDateWithIndex: index)
        self.view.layer.opacity = 1.0
        optionTable.reloadData()
    }
}

// MARK: - NoteViewControllerDelegate
extension TaskModificationViewController: NoteViewControllerDelegate{
    func noteViewControllerDidTapAtDone(_ viewController: UIViewController) {
        optionTable.reloadData()
    }
}


@objc protocol TaskModificationViewControllerDelegate{
    @objc optional func taskModificationViewController(_ viewController: UIViewController, didTapAddDueDateWithDue due: Date?, didTapAddDueDateWithIndex index: Int)
    @objc optional func taskModificationViewControllerDidChangeTask(_ viewController: UIViewController)
    @objc optional func taskModificationViewController(_ viewController: UIViewController, didTapDeleteWithTask task: Task)
}
