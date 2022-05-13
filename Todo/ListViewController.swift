//
//  MyDayViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class ListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var addTaskField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var myDayToggleButton: UIButton!
    @IBOutlet weak var reminderToggleButton: UIButton!
    @IBOutlet weak var dueToggleButton: UIButton!
    @IBOutlet weak var addTaskOptions: UIStackView!
    @IBOutlet weak var addTaskFunction: UIStackView!
    @IBOutlet weak var editOptions: UIStackView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var setDueButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var myButtons: [UIButton]!
    
    var filterIndex = 0
    var myDayIsOn = false
    var reminderIsOn = false
    var dueIsOn = false
    var dueType: dueType?
    var dueDate: Date?
    var isEditMode = false
    var listOptionBarButtonItem = UIBarButtonItem()
    var isSelected = false
    var isSelectedAll = false
    var selectedListId: String?
    var selectedArr: [Task]?
    var isThemeWhite: Bool = true
    
    var list: List!
    var taskStore: TaskStore!
    var listStore: ListStore!
    
    func changeButtonColor(){
        if isThemeWhite{
            for button in self.myButtons {
                button.setTitleColor(UIColor.link, for: .normal)
                button.tintColor = UIColor.link
            }
            listOptionBarButtonItem.tintColor = UIColor.link
            self.navigationController?.navigationBar.tintColor = UIColor.link
        }
        else{
            for button in self.myButtons {
                button.setTitleColor(UIColor.white, for: .normal)
                button.tintColor = UIColor.white
            }
            listOptionBarButtonItem.tintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    }
    
    @IBAction func addTask(_ sender: UIButton){
        if let taskName = addTaskField.text, !taskName.isEmpty{
            var newTask = Task(name: taskName, type: .listed, isMyDay: false)
            newTask.listID = list.id
            
            if myDayIsOn == true{
                newTask.isMyDay = true
            }
            if reminderIsOn == true{
                
            }
            if dueIsOn == true{
                switch dueType{
                case .today:
                    newTask.dueDate = dueDate
                    
                case .tomorrow:
                    newTask.dueDate = dueDate
                    
                case .nextWeek:
                    newTask.dueDate = dueDate
                    
                case .optional:
                    newTask.dueDate = dueDate
                default:
                    break
                }
            }
            newTask = list.createTask(name: newTask.name, type: newTask.type, date: newTask.dueDate, isMyDay: newTask.isMyDay, listId: newTask.listID)

            taskStore.allListedTask.append(newTask)
            
            var indexPath = IndexPath()

            if let index = list.unfinishedTask.lastIndex(of: newTask){
                indexPath = IndexPath(row: index, section: 0)
            }
            taskTable.insertRows(at: [indexPath], with: .automatic)
            addTaskField.text = .none
        }
    }
    
    @IBAction func toggleMyDay(_ sender: UIButton){
        if myDayIsOn == false{
            myDayIsOn = true
            myDayToggleButton.setImage(UIImage(systemName: "sun.min.fill"), for: .normal)
            myDayToggleButton.setTitle("My Day", for: .normal)
        }
        else{
            myDayIsOn = false
            myDayToggleButton.setImage(UIImage(systemName: "sun.min"), for: .normal)
            myDayToggleButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction func toggleReminder(_ sender: UIButton){
        if reminderIsOn == false{
            reminderIsOn = true
            reminderToggleButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
            reminderToggleButton.setTitle("Remind me at ", for: .normal)
        }
        else{
            reminderIsOn = false
            reminderToggleButton.setImage(UIImage(systemName: "bell"), for: .normal)
            reminderToggleButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction func toggleDue(_ sender: UIButton){
        
        if dueIsOn == false{
            let dueViewController = DueViewController()
            dueViewController.delegate = self
            present(dueViewController, animated: true, completion: nil)
        }
        else{
            dueIsOn = false
            dueType = .none
            dueToggleButton.setImage(UIImage(systemName: "calendar.circle"), for: .normal)
            dueToggleButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction func selectAllTask(_ sender: UIButton) {
//        let attributeText = NSMutableAttributedString(string: sender.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
//        sender.setAttributedTitle(attributeText, for: .normal)
        
        if isSelectedAll == false{
            isSelected = true
            isSelectedAll = true
            if list.unfinishedTask.count > 0{
                for i in 0...(list.unfinishedTask.count - 1){
                    list.unfinishedTask[i].isSelected = true
                }
            }
            if list.finishedTask.count > 0{
                for i in 0...(list.finishedTask.count - 1){
                    list.finishedTask[i].isSelected = true
                }
            }
            selectAllButton.setTitle("Clear all", for: .normal)
        }
        else{
            isSelected = false
            isSelectedAll = false
            if list.unfinishedTask.count > 0{
                for i in 0...(list.unfinishedTask.count - 1){
                    list.unfinishedTask[i].isSelected = false
                }
            }
            if list.finishedTask.count > 0{
                for i in 0...(list.finishedTask.count - 1){
                    list.finishedTask[i].isSelected = false
                }
            }
            selectAllButton.setTitle("Select all", for: .normal)
        }
        let attributeText = NSMutableAttributedString(string: sender.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
        sender.setAttributedTitle(attributeText, for: .normal)
        taskTable.reloadSections([0,1], with: .automatic)
    }
    
    @IBAction func moveTask(_ sender: UIButton){
        if isSelected{
            let listSelectorViewController = ListSelectorViewController()
            listSelectorViewController.delegate = self
            listSelectorViewController.isEditMode = isEditMode
            listSelectorViewController.listStore = listStore
            present(listSelectorViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func setDueDate(_ sender: UIButton){
        if isSelected{
            let dueViewController = DueViewController()
            dueViewController.delegate = self
            present(dueViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteSelected(_ sender: UIButton){
        if isSelected{
            for tmpTask in list.allTask{
                let index = list.allTask.firstIndex(where: {$0.id == tmpTask.id})
                if tmpTask.isSelected{
                    list.allTask.remove(at: index!)
                }
            }
            taskTable.reloadSections([0, 1], with: .automatic)
        }
    }
    
    @objc func listOptions(_ sender: UIBarButtonItem){
        if isEditMode == false{
            let listOptionsViewController = ListOptionsViewController()
            listOptionsViewController.isDuplicatable = true
            listOptionsViewController.delegate = self
            present(listOptionsViewController, animated: true, completion: nil)
        }
        else{
            self.addTaskOptions.isHidden = false
            self.addTaskFunction.isHidden = false
            self.editOptions.isHidden = true
            isEditMode = false
            listOptionBarButtonItem.title = ""
            listOptionBarButtonItem.image = UIImage(systemName: "ellipsis")
            taskTable.reloadSections([0, 1], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listOptionBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(listOptions))
        listOptionBarButtonItem.image = UIImage(systemName: "ellipsis")
        
        self.navigationItem.rightBarButtonItem  = listOptionBarButtonItem
        
        taskTable.delegate = self
        taskTable.dataSource = self
        self.taskTable.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        
        taskTable.rowHeight = 60
        
    }
    override func viewWillAppear(_ animated: Bool) {
        changeButtonColor()
        self.taskTable.reloadSections([0, 1], with: .automatic)
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
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return list.unfinishedTask.count
        }
        else{
            return list.finishedTask.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.isEditMode = isEditMode
        cell.listStore = listStore
        if indexPath.section == 0{
            cell.task = list.unfinishedTask[indexPath.row]
            cell.createCell(name: list.unfinishedTask[indexPath.row].name)
        }
        else{
            cell.task = list.finishedTask[indexPath.row]
            cell.createCell(name: list.finishedTask[indexPath.row].name)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return list.name
        }
        else{
            if list.finishedTask.count != 0{
                return "Finished"
            }
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task: Task
            if indexPath.section == 0{
                task = list.unfinishedTask[indexPath.row]
            }
            else{
                task = list.finishedTask[indexPath.row]
            }
            list.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskModificationViewController = TaskModificationViewController(nibName: "TaskModificationViewController", bundle: .main)
        let task: Task
        if indexPath.section == 0{
            task = list.unfinishedTask[indexPath.row]
        }
        else {
            task = list.finishedTask[indexPath.row]
        }
        taskModificationViewController.task = task
        taskModificationViewController.delegate = self
        navigationController?.pushViewController(taskModificationViewController, animated: true)
    }
}

extension ListViewController: TaskTableViewCellDelegate{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task) {
        let state = task.isFinished
        if state == false{
            task.isFinished = true
        }
        else{
            task.isFinished = false
        }
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task) {
        let state = task.isImportant
        if state == false{
            for tmpTask in list.allTask {
                if tmpTask.id == task.id{
                    task.isImportant = true
                }
            }
        }
        else{
            for tmpTask in list.allTask {
                if tmpTask.id == task.id{
                    task.isImportant = false
                }
            }
        }
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapCheckButtonWithTask task: Task) {
        for tmpTask in taskStore.allTask{
            if tmpTask.id == task.id{
                if task.isSelected == false{
                    task.isSelected = true
                }
                else{
                    isSelectedAll = false
                    task.isSelected = false
                }
            }
        }
        isSelected = false
        selectedArr = []
        for tmpTask in taskStore.unfinishedTask{
            if tmpTask.isSelected{
                isSelected = true
                selectedArr?.append(tmpTask)
            }
        }
        for tmpTask in taskStore.finishedTask{
            if tmpTask.isSelected{
                isSelected = true
                selectedArr?.append(tmpTask)
            }
        }
        if selectedArr?.count == taskStore.finishedTask.count + taskStore.unfinishedTask.count{
            isSelectedAll = true
            selectAllButton.setTitle("Clear all", for: .normal)
            let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
            selectAllButton.setAttributedTitle(attributeText, for: .normal)
        }
        else{
            isSelectedAll = false
            selectAllButton.setTitle("Select all", for: .normal)
            let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
            selectAllButton.setAttributedTitle(attributeText, for: .normal)
        }
        taskTable.reloadSections([0, 1], with: .automatic)
    }
}

// MARK: - DueViewControllerDelegate
extension ListViewController: DueViewControllerDelegate{
    func dueViewController(_ viewController: UIViewController, didTapAtIndex index: Int, dateForIndex date: Date?){
        var due = String()
        let cell = DueTableViewCell()
        let nextWeekDate = cell.getNextWeek()
        dueDate = date
        
        switch index{
        case 0:
            dueType = .today
            due = " Today"
        case 1:
            dueType = .tomorrow
            due = " Tomorrow"
        case 2:
            dueType = .nextWeek
            due = " " + nextWeekDate!
        case 3:
            if date != nil{
                dueType = .optional
                due = " " + dueDate!.date
            }
        default:
            break
        }
        
        if isEditMode == false{
            if date != nil{
                dueIsOn = true
                dueToggleButton.setTitle("Due" + due, for: .normal)
                dueToggleButton.setImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
            }
        }
        else{
            for tmpTask in taskStore.allTask{
                if tmpTask.isSelected{
                    tmpTask.dueDate = date
                    tmpTask.isSelected = false
                }
            }
            taskTable.reloadSections([0, 1], with: .automatic)
        }
    }
}

// MARK: - TaskModificationViewControllerDelegate
extension ListViewController: TaskModificationViewControllerDelegate{
    func taskModificationViewController(_ viewController: UIViewController) {
        taskTable.reloadSections([0, 1], with: .automatic)
    }
}

// MARK: - ListOptionsViewControllerDelegate
extension ListViewController: ListOptionsViewControllerDelegate{
    func listOptionsViewController(_ viewController: UIViewController, didTapAtEdit bool: Bool) {
        self.addTaskOptions.isHidden = true
        self.addTaskFunction.isHidden = true
        self.editOptions.isHidden = false
        isEditMode = true
        isSelectedAll = false
        listOptionBarButtonItem.title = "Cancel"
        listOptionBarButtonItem.image = .none
        if list.unfinishedTask.count > 0{
            for i in 0...(list.unfinishedTask.count - 1){
                list.unfinishedTask[i].isSelected = false
            }
        }
        if list.finishedTask.count > 0{
            for i in 0...(list.finishedTask.count - 1){
                list.finishedTask[i].isSelected = false
            }
        }
        selectAllButton.setTitle("Select all", for: .normal)
        let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
        selectAllButton.setAttributedTitle(attributeText, for: .normal)

        taskTable.reloadSections([0,1], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtImportance bool: Bool, didSelectSortOptionsWithIndex index: Int) {
        switch index{
        case 0:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.isImportant && !$1.isImportant})
        case 1:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.name < $1.name})
        case 2:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.dueDate! < $1.dueDate!})
        case 3:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.isMyDay && !$1.isMyDay})
        default:
            break
        }
        taskTable.reloadSections([0,1], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtChangeTheme bool: Bool, didSelectThemeWithType type: themeType) {
        if type == .white{
            isThemeWhite = true
        }
        else{
            isThemeWhite = false
        }
        switch type {
        case .white:
            view.backgroundColor = UIColor.white
            taskTable.backgroundColor = UIColor.white
        case .red:
            view.backgroundColor = UIColor.systemRed
            taskTable.backgroundColor = UIColor.systemRed
        case .blue:
            view.backgroundColor = UIColor.systemBlue
            taskTable.backgroundColor = UIColor.systemBlue
        case .green:
            view.backgroundColor = UIColor.systemGreen
            taskTable.backgroundColor = UIColor.systemGreen
        case .yellow:
            view.backgroundColor = UIColor.systemYellow
            taskTable.backgroundColor = UIColor.systemYellow
        case .purple:
            view.backgroundColor = UIColor.systemPurple
            taskTable.backgroundColor = UIColor.systemPurple
        case .teal:
            view.backgroundColor = UIColor.systemTeal
            taskTable.backgroundColor = UIColor.systemTeal
        }
        changeButtonColor()
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDuplicateList bool: Bool) {
        let newList = listStore.createList(name: list.name)
        for tmpTask in self.list.allTask{
            tmpTask.listID = newList.id
            newList.allTask.append(tmpTask)
        }
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    
}

// MARK: - ListSelectorViewControllerDelegate
extension ListViewController: ListSelectorViewControllerDelegate{
    func listSelectorViewController(_ viewController: UIViewController, selectForListOptions bool: Bool, listForIndex list: List?) {
        for tmpList in listStore.allList{
            if tmpList.id == list?.id{
                
                for tmpTask in self.list.allTask{
                    if tmpTask.isSelected{
                        let index = self.list.allTask.firstIndex(where: {$0.id == tmpTask.id})
                        tmpTask.listID = list!.id
                        tmpList.allTask.append(tmpTask)
                        self.list.allTask.remove(at: index!)
                    }
                }
        
            }
        }
        taskTable.reloadSections([0, 1], with: .automatic)
    }
     
    func listSelectorViewController(_ viewController: UIViewController, selectForAddTask bool: Bool, listForIndex list: List?) {
        
    }
}


