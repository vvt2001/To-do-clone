//
//  PlannedViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class PlannedViewController: UIViewController, UITextFieldDelegate {
    
    var taskStore: TaskStore!
    var listStore: ListStore!

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var addTaskField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
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
    var selectedListId: String?
    var isEditMode = false
    var listOptionBarButtonItem = UIBarButtonItem()
    var isSelected = false
    var isSelectedAll = false
    var selectedArr: [Task]?
    var isThemeWhite: Bool = true
    
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
    
    @IBAction func changeOption(_ sender: UIButton){
        let filterViewController = PlannedFilterOptionsViewController()
        filterViewController.delegate = self
        present(filterViewController, animated: true, completion: nil)
    }
    
    @IBAction func addTask(_ sender: UIButton){
        if let taskName = addTaskField.text, !taskName.isEmpty{
            let newTask = Task(name: taskName, type: .planned, isMyDay: false)
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
            else{
                switch filterIndex{
                case 0:
                    newTask.dueDate = Date()
//                    newTask = taskStore.createPlannedTask(name: addTaskField.text, type: .planned, date: dueDate)
//                    var indexPath = IndexPath()
//                    if let index = taskStore.allPlannedTask.lastIndex(of: newTask){
//                        indexPath = IndexPath(row: index, section: 0)
//                    }
//                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 1:
                    newTask.dueDate = Date()
//                    _ = taskStore.createPlannedTask(name: addTaskField.text, type: .planned, date: dueDate)
                case 2:
                    newTask.dueDate = Date()
//                    let newTask = taskStore.createPlannedTask(name: addTaskField.text, type: .planned, date: dueDate)
//                    var indexPath = IndexPath()
//                    if let index = taskStore.todayTask.lastIndex(of: newTask){
//                        indexPath = IndexPath(row: index, section: 0)
//                    }
//                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 3:
                    var dateComponent = DateComponents()
                    dateComponent.day = 1
                    newTask.dueDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
//                    let newTask = taskStore.createPlannedTask(name: addTaskField.text, type: .planned, date: dueDate)
//                    var indexPath = IndexPath()
//                    if let index = taskStore.tomorrowTask.lastIndex(of: newTask){
//                        indexPath = IndexPath(row: index, section: 0)
//                    }
//                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 4:
                    newTask.dueDate = Date()
//                    let newTask = taskStore.createPlannedTask(name: addTaskField.text, type: .planned, date: dueDate)
//                    var indexPath = IndexPath()
//                    if let index = taskStore.thisWeekTask.lastIndex(of: newTask){
//                        indexPath = IndexPath(row: index, section: 0)
//                    }
//                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 5:
                    var dateComponent = DateComponents()
                    dateComponent.day = 7
                    newTask.dueDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
//                    let newTask = taskStore.createPlannedTask(name: addTaskField.text, type: .planned, date: dueDate)
//                    var indexPath = IndexPath()
//                    if let index = taskStore.laterTask.lastIndex(of: newTask){
//                        indexPath = IndexPath(row: index, section: 0)
//                    }
//                    taskTable.insertRows(at: [indexPath], with: .automatic)
                default:
                    break
                }
                
            }
            _ = taskStore.createTask(name: newTask.name, type: newTask.type, date: newTask.dueDate, isMyDay: newTask.isMyDay)
            taskTable.reloadSections([0], with: .automatic)
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
            if taskStore.allPlannedTask.count > 0{
                for i in 0...(taskStore.allPlannedTask.count - 1){
                    taskStore.allPlannedTask[i].isSelected = true
                }
            }
            selectAllButton.setTitle("Clear all", for: .normal)
        }
        else{
            isSelected = false
            isSelectedAll = false
            if taskStore.allPlannedTask.count > 0{
                for i in 0...(taskStore.allPlannedTask.count - 1){
                    taskStore.allPlannedTask[i].isSelected = false
                }
            }
            selectAllButton.setTitle("Select all", for: .normal)
        }
        let attributeText = NSMutableAttributedString(string: sender.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
        sender.setAttributedTitle(attributeText, for: .normal)
        taskTable.reloadSections([0], with: .automatic)
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
            for tmpTask in taskStore.allTask{
                let index = taskStore.allTask.firstIndex(where: {$0.id == tmpTask.id})
                if tmpTask.isSelected{
                    taskStore.allTask.remove(at: index!)
                }
            }
            taskTable.reloadSections([0], with: .automatic)
        }
    }
    
    @objc func listOptions(_ sender: UIBarButtonItem){
        if isEditMode == false{
            let listOptionsViewController = ListOptionsViewController()
            listOptionsViewController.isDuplicatable = false
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
            taskTable.reloadSections([0], with: .automatic)
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
        self.taskTable.reloadSections([0], with: .automatic)
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
        print(taskStore.tomorrowTask.count)
        var rowInSection = Int()
        switch filterIndex{
        case 0:
            rowInSection = taskStore.allPlannedTask.count
        case 1:
            rowInSection = taskStore.overdueTask.count
        case 2:
            rowInSection = taskStore.todayTask.count
        case 3:
            rowInSection = taskStore.tomorrowTask.count
        case 4:
            rowInSection = taskStore.thisWeekTask.count
        case 5:
            rowInSection = taskStore.laterTask.count
        default:
            break
        }
        return rowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.isEditMode = isEditMode
        cell.listStore = listStore
        switch filterIndex{
        case 0:
            cell.task = taskStore.allPlannedTask[indexPath.row]
            cell.createCell(name: taskStore.allPlannedTask[indexPath.row].name)
        case 1:
            cell.task = taskStore.overdueTask[indexPath.row]
            cell.createCell(name: taskStore.overdueTask[indexPath.row].name)
        case 2:
            cell.task = taskStore.todayTask[indexPath.row]
            cell.createCell(name: taskStore.todayTask[indexPath.row].name)
        case 3:
            cell.task = taskStore.tomorrowTask[indexPath.row]
            cell.createCell(name: taskStore.tomorrowTask[indexPath.row].name)
        case 4:
            cell.task = taskStore.thisWeekTask[indexPath.row]
            cell.createCell(name: taskStore.thisWeekTask[indexPath.row].name)
        case 5:
            cell.task = taskStore.laterTask[indexPath.row]
            cell.createCell(name: taskStore.laterTask[indexPath.row].name)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Planned"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task: Task
            if indexPath.section == 0{
                task = taskStore.unfinishedTask[indexPath.row]
            }
            else{
                task = taskStore.finishedTask[indexPath.row]
            }
            taskStore.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskModificationViewController = TaskModificationViewController(nibName: "TaskModificationViewController", bundle: .main)
        let task: Task
        switch filterIndex{
        case 0:
            task = taskStore.allPlannedTask[indexPath.row]
        case 1:
            task = taskStore.overdueTask[indexPath.row]
        case 2:
            task = taskStore.todayTask[indexPath.row]
        case 3:
            task = taskStore.tomorrowTask[indexPath.row]
        case 4:
            task = taskStore.thisWeekTask[indexPath.row]
        case 5:
            task = taskStore.laterTask[indexPath.row]
        default:
            task = taskStore.allPlannedTask[indexPath.row]
        }
        taskModificationViewController.task = task
        taskModificationViewController.delegate = self
        navigationController?.pushViewController(taskModificationViewController, animated: true)
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
        for tmpTask in taskStore.allPlannedTask{
            if tmpTask.isSelected{
                isSelected = true
                selectedArr?.append(tmpTask)
            }
        }
        if selectedArr?.count == taskStore.allPlannedTask.count{
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
        taskTable.reloadSections([0], with: .automatic)
    }
}

// MARK: - PlannedFilterOptionsViewControllerDelegate
extension PlannedViewController: PlannedFilterOptionsViewControllerDelegate{
    func plannedFilterOptionsViewController(_ viewController: UIViewController, didTapAtIndex index: Int) {
        filterIndex = index
        switch index{
        case 0:
            optionButton.setTitle("All planned", for: .normal)
        case 1:
            optionButton.setTitle("Overdue", for: .normal)
        case 2:
            optionButton.setTitle("Today", for: .normal)
        case 3:
            optionButton.setTitle("Tomorrow", for: .normal)
        case 4:
            optionButton.setTitle("This week", for: .normal)
        case 5:
            optionButton.setTitle("Later", for: .normal)
        default:
            break
        }
        taskTable.reloadSections([0], with: .automatic)
    }
}

// MARK: - DueViewControllerDelegate
extension PlannedViewController: DueViewControllerDelegate{
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
            taskTable.reloadSections([0], with: .automatic)
        }
    }
}

// MARK: - TaskModificationViewControllerDelegate
extension PlannedViewController: TaskModificationViewControllerDelegate{
    func taskModificationViewController(_ viewController: UIViewController) {
        taskTable.reloadSections([0], with: .automatic)
    }
}

// MARK: - ListOptionsViewControllerDelegate
extension PlannedViewController: ListOptionsViewControllerDelegate{
    func listOptionsViewController(_ viewController: UIViewController, didTapAtEdit bool: Bool) {
        filterIndex = 0
        optionButton.setTitle("All planned", for: .normal)
        self.addTaskOptions.isHidden = true
        self.addTaskFunction.isHidden = true
        self.editOptions.isHidden = false
        isEditMode = true
        isSelectedAll = false
        listOptionBarButtonItem.title = "Cancel"
        listOptionBarButtonItem.image = .none
        if taskStore.importantTask.count > 0{
            for i in 0...(taskStore.importantTask.count - 1){
                taskStore.importantTask[i].isSelected = false
            }
        }
        selectAllButton.setTitle("Select all", for: .normal)
        let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
        selectAllButton.setAttributedTitle(attributeText, for: .normal)

        taskTable.reloadSections([0], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtImportance bool: Bool, didSelectSortOptionsWithIndex index: Int) {
        switch index{
        case 0:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.isImportant && !$1.isImportant})
        case 1:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.name < $1.name})
        case 2:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.dueDate ?? Date() < $1.dueDate ?? Date()})
        case 3:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.isMyDay && !$1.isMyDay})
        default:
            break
        }
        taskTable.reloadSections([0], with: .automatic)
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

    }
}

// MARK: - ListSelectorViewControllerDelegate
extension PlannedViewController: ListSelectorViewControllerDelegate{
    func listSelectorViewController(_ viewController: UIViewController, selectForAddTask bool: Bool, listForIndex list: List?) {

    }
    func listSelectorViewController(_ viewController: UIViewController, selectForListOptions bool: Bool, listForIndex list: List?) {
        for tmpList in listStore.allList{
            if tmpList.id == list?.id{
                
                for tmpTask in taskStore.allPlannedTask{
                    if tmpTask.isSelected{
                        let currentListId = tmpTask.listID
                        if currentListId != "" {
                            let listIndex = listStore.allList.firstIndex(where: {$0.id == currentListId})
                            let index = listStore.allList[listIndex!].allTask.firstIndex(where: {$0.id == tmpTask.id})
                            tmpTask.listID = list!.id
                            tmpList.allTask.append(tmpTask)
                            listStore.allList[listIndex!].allTask.remove(at: index!)
                        }
                        else{
                            let index = taskStore.allTask.firstIndex(where: {$0.id == tmpTask.id})
                            if tmpTask.isSelected{
                                tmpTask.listID = list!.id
                                tmpList.allTask.append(tmpTask)
                                taskStore.allListedTask.append(tmpTask)
                                taskStore.allTask.remove(at: index!)
                            }
                        }
                    }
                }
                
            }
        }
        taskTable.reloadSections([0], with: .automatic)
    }
}
