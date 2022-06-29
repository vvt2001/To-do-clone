//
//  PlannedViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class PlannedViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    var taskStore: TaskStore!
    var listStore: ListStore!
    var account: Account!

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
            addTaskField.attributedPlaceholder = NSAttributedString(string: "Add a Task", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            addTaskField.textColor = UIColor.black
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        }
        else{
            for button in self.myButtons {
                button.setTitleColor(UIColor.white, for: .normal)
                button.tintColor = UIColor.white
            }
            listOptionBarButtonItem.tintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
            addTaskField.attributedPlaceholder = NSAttributedString(string: "Add a Task", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            addTaskField.textColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
    }
    
    @IBAction func changeOption(_ sender: UIButton){
        let filterViewController = PlannedFilterOptionsViewController()
        filterViewController.transitioningDelegate = self
        filterViewController.modalTransitionStyle = .coverVertical
        filterViewController.modalPresentationStyle = .custom
        filterViewController.delegate = self
        self.view.layer.opacity = 0.5
        self.present(filterViewController, animated: true, completion: nil)
    }
    
    private func requestNotification(task: Task){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Task Management", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "'\(task.getName())' is about to meets due. Make sure to finish it.", arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var remindDate = Date()
        if let dueDate = self.dueDate {
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
    
    @IBAction func addTask(_ sender: UIButton){
        if let taskName = addTaskField.text, !taskName.isEmpty{
            let newTask = Task(name: taskName, type: .planned, isMyDay: false)
            newTask.setAccountId(accountID: account.getID())

            if myDayIsOn == true{
                newTask.setIsMyDay(isMyDay: true)
            }
            if reminderIsOn == true{
                requestNotification(task: newTask)
            }
            if dueIsOn == true{
                switch dueType{
                case .today:
                    newTask.setDueDate(dueDate: dueDate)
                    
                case .tomorrow:
                    newTask.setDueDate(dueDate: dueDate)
                    
                case .nextWeek:
                    newTask.setDueDate(dueDate: dueDate)
                    
                case .optional:
                    newTask.setDueDate(dueDate: dueDate)
                default:
                    break
                }
            }
            else{
                switch filterIndex{
                case 0:
                    newTask.setDueDate(dueDate: Date())
                    taskStore.addTask(task: newTask)
                    var indexPath = IndexPath()
                    if let index = taskStore.allPlannedTask.lastIndex(where: {$0.getId() == newTask.getId()}){
                        indexPath = IndexPath(row: index, section: 0)
                    }
                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 1:
                    newTask.setDueDate(dueDate: Date())
                    taskStore.addTask(task: newTask)
                case 2:
                    newTask.setDueDate(dueDate: Date())
                    taskStore.addTask(task: newTask)
                    var indexPath = IndexPath()
                    if let index = taskStore.todayTask.lastIndex(where: {$0.getId() == newTask.getId()}){
                        indexPath = IndexPath(row: index, section: 0)
                    }
                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 3:
                    var dateComponent = DateComponents()
                    dateComponent.day = 1
                    newTask.setDueDate(dueDate: Calendar.current.date(byAdding: dateComponent, to: Date())!)
                    taskStore.addTask(task: newTask)
                    var indexPath = IndexPath()
                    if let index = taskStore.tomorrowTask.lastIndex(where: {$0.getId() == newTask.getId()}){
                        indexPath = IndexPath(row: index, section: 0)
                    }
                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 4:
                    newTask.setDueDate(dueDate: Date())
                    taskStore.addTask(task: newTask)
                    var indexPath = IndexPath()
                    if let index = taskStore.thisWeekTask.lastIndex(where: {$0.getId() == newTask.getId()}){
                        indexPath = IndexPath(row: index, section: 0)
                    }
                    taskTable.insertRows(at: [indexPath], with: .automatic)
                case 5:
                    var dateComponent = DateComponents()
                    dateComponent.day = 7
                    newTask.setDueDate(dueDate: Calendar.current.date(byAdding: dateComponent, to: Date())!)
                    taskStore.addTask(task: newTask)
                    var indexPath = IndexPath()
                    if let index = taskStore.laterTask.lastIndex(where: {$0.getId() == newTask.getId()}){
                        indexPath = IndexPath(row: index, section: 0)
                    }
                    taskTable.insertRows(at: [indexPath], with: .automatic)
                default:
                    break
                }
                
            }
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
            if dueIsOn{
                reminderToggleButton.setTitle("Remind me before due", for: .normal)
            }
            else{
                reminderToggleButton.setTitle("Remind me today", for: .normal)
            }
        }
        else{
            reminderIsOn = false
            reminderToggleButton.setImage(UIImage(systemName: "bell"), for: .normal)
            reminderToggleButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction func toggleDue(_ sender: UIButton){
        
        if dueIsOn == false{
            presentDueViewController()
        }
        else{
            dueIsOn = false
            dueType = .none
            dueToggleButton.setImage(UIImage(systemName: "calendar.circle"), for: .normal)
            dueToggleButton.setTitle("", for: .normal)
            if reminderIsOn{
                reminderToggleButton.setTitle("Remind me today", for: .normal)
            }
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
                    taskStore.allPlannedTask[i].setIsSelected(isSelected: true)
                }
            }
            selectAllButton.setTitle("Clear all", for: .normal)
        }
        else{
            isSelected = false
            isSelectedAll = false
            if taskStore.allPlannedTask.count > 0{
                for i in 0...(taskStore.allPlannedTask.count - 1){
                    taskStore.allPlannedTask[i].setIsSelected(isSelected: false)
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
            presentListSelectorViewController()
        }
    }
    
    @IBAction func setDueDate(_ sender: UIButton){
        if isSelected{
            presentDueViewController()
        }
    }
    
    @IBAction func deleteSelected(_ sender: UIButton){
        if isSelected{
            for tmpTask in taskStore.allTask{
                let index = taskStore.allTask.firstIndex(where: {$0.getId() == tmpTask.getId()})
                if tmpTask.getIsSelected(){
                    taskStore.allTask.remove(at: index!)
                }
            }
            taskTable.reloadSections([0], with: .automatic)
        }
    }
    
    @objc func listOptions(_ sender: UIBarButtonItem){
        if isEditMode == false{
            presentListOptionsViewController()
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
    
    private func changeTheme(type: themeType){
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
        taskTable.reloadData()
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
        self.title = "Planned"
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        changeTheme(type: account.getCurrentThemeType())
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlannedViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlannedViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeTheme(type: account.getCurrentThemeType())
        self.taskTable.reloadSections([0], with: .automatic)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.link
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func presentDueViewController(){
        let dueViewController = DueViewController()
        dueViewController.transitioningDelegate = self
        dueViewController.modalTransitionStyle = .coverVertical
        dueViewController.modalPresentationStyle = .custom
        dueViewController.delegate = self
        self.view.layer.opacity = 0.5
        self.present(dueViewController, animated: true, completion: nil)
    }
    
    func presentListOptionsViewController(){
        let listOptionsViewController = ListOptionsViewController()
        listOptionsViewController.modalTransitionStyle = .coverVertical
        listOptionsViewController.modalPresentationStyle = .custom
        listOptionsViewController.transitioningDelegate = self
        listOptionsViewController.delegate = self
        listOptionsViewController.isDuplicatable = false
        self.present(listOptionsViewController, animated: true, completion: nil)
        self.view.layer.opacity = 0.5
    }
    
    func presentListSelectorViewController(){
        let listSelectorViewController = ListSelectorViewController()
        listSelectorViewController.modalTransitionStyle = .coverVertical
        listSelectorViewController.modalPresentationStyle = .custom
        listSelectorViewController.transitioningDelegate = self
        listSelectorViewController.isEditMode = isEditMode
        listSelectorViewController.listStore = listStore
        listSelectorViewController.delegate = self
        self.present(listSelectorViewController, animated: true, completion: nil)
        self.view.layer.opacity = 0.5
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var isMoved: Bool = false
    @objc func keyboardWillShow(notification: NSNotification) {
        if(isMoved)
        {
            return
        }
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }

      // move the root view up by the distance of keyboard height
        bottomConstraint.constant -= (keyboardSize.height - 30)
        isMoved =  true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        bottomConstraint.constant = 0
        isMoved = false
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
        cell.selectionStyle = .none
        
        switch filterIndex{
        case 0:
            cell.task = taskStore.allPlannedTask[indexPath.row]
            cell.createCell(name: taskStore.allPlannedTask[indexPath.row].getName())
        case 1:
            cell.task = taskStore.overdueTask[indexPath.row]
            cell.createCell(name: taskStore.overdueTask[indexPath.row].getName())
        case 2:
            cell.task = taskStore.todayTask[indexPath.row]
            cell.createCell(name: taskStore.todayTask[indexPath.row].getName())
        case 3:
            cell.task = taskStore.tomorrowTask[indexPath.row]
            cell.createCell(name: taskStore.tomorrowTask[indexPath.row].getName())
        case 4:
            cell.task = taskStore.thisWeekTask[indexPath.row]
            cell.createCell(name: taskStore.thisWeekTask[indexPath.row].getName())
        case 5:
            cell.task = taskStore.laterTask[indexPath.row]
            cell.createCell(name: taskStore.laterTask[indexPath.row].getName())
        default:
            break
        }
        
        return cell
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
            taskStore.deleteTask(task: task)
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if isThemeWhite{
            header.textLabel?.textColor = UIColor.gray
        }
        else{
            header.textLabel?.textColor = UIColor.white
        }
    }
}

// MARK: - TaskTableViewCellDelegate
extension PlannedViewController: TaskTableViewCellDelegate{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task) {
        task.setIsFinished(isFinished: true)
        taskTable.reloadSections([0], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task) {
        let state = task.getIsImportant()
        if state == false{
            for tmpTask in taskStore.allTask {
                if tmpTask.getId() == task.getId(){
                    task.setIsImportant(isImportant: true)
                }
            }
        }
        else{
            for tmpTask in taskStore.allTask {
                if tmpTask.getId() == task.getId(){
                    task.setIsImportant(isImportant: false)
                }
            }
        }
        taskTable.reloadSections([0], with: .automatic)
    }
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapCheckButtonWithTask task: Task) {
        for tmpTask in taskStore.allTask{
            if tmpTask.getId() == task.getId(){
                if task.getIsSelected() == false{
                    task.setIsSelected(isSelected: true)
                }
                else{
                    isSelectedAll = false
                    task.setIsSelected(isSelected: false)
                }
            }
        }
        isSelected = false
        selectedArr = []
        for tmpTask in taskStore.allPlannedTask{
            if tmpTask.getIsSelected(){
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
    func plannedFilterOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTable.reloadData()
    }
    
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
    func dueViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTable.reloadData()
    }
    
    func dueViewController(_ viewController: UIViewController, didTapAtIndex index: Int, dateForIndex date: Date?){
        self.view.layer.opacity = 1.0
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
                if reminderIsOn{
                    reminderToggleButton.setTitle("Remind me before due", for: .normal)
                }
            }
        }
        else{
            for tmpTask in taskStore.allTask{
                if tmpTask.getIsSelected(){
                    tmpTask.setDueDate(dueDate: date)
                    tmpTask.setIsSelected(isSelected: false)
                }
            }
            taskTable.reloadSections([0], with: .automatic)
        }
    }
}

// MARK: - TaskModificationViewControllerDelegate
extension PlannedViewController: TaskModificationViewControllerDelegate{
    func taskModificationViewControllerDidChangeTask(_ viewController: UIViewController) {
        taskTable.reloadSections([0], with: .automatic)
    }
    func taskModificationViewController(_ viewController: UIViewController, didTapDeleteWithTask task: Task) {
        taskStore.deleteTask(task: task)
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
                taskStore.importantTask[i].setIsSelected(isSelected: false)
            }
        }
        selectAllButton.setTitle("Select all", for: .normal)
        let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
        selectAllButton.setAttributedTitle(attributeText, for: .normal)

        self.view.layer.opacity = 1.0
        taskTable.reloadSections([0], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtImportance bool: Bool, didSelectSortOptionsWithIndex index: Int) {
        switch index{
        case 0:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.getIsImportant() && !$1.getIsImportant()})
        case 1:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.getName() < $1.getName()})
        case 2:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.getDueDate()! < $1.getDueDate()!})
        case 3:
            taskStore.allTask = taskStore.allTask.sorted(by: {$0.getIsMyDay() && !$1.getIsMyDay()})
        default:
            break
        }
        self.view.layer.opacity = 1.0
        taskTable.reloadSections([0], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtChangeTheme bool: Bool, didSelectThemeWithType type: themeType) {
        account.setCurrentThemeType(currentThemeType: type)
        changeTheme(type: type)
        self.view.layer.opacity = 1.0
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDuplicateList bool: Bool) {

    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTable.reloadData()
    }
}

// MARK: - ListSelectorViewControllerDelegate
extension PlannedViewController: ListSelectorViewControllerDelegate{
    func listSelectorViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTable.reloadData()
    }
    
    func listSelectorViewController(_ viewController: UIViewController, selectForAddTask bool: Bool, listForIndex list: List?) {

    }
    func listSelectorViewController(_ viewController: UIViewController, selectForListOptions bool: Bool, listForIndex list: List?) {
        for tmpList in listStore.allList{
            if tmpList.getListID() == list?.getListID(){
                
                for tmpTask in taskStore.allPlannedTask{
                    if tmpTask.getIsSelected(){
                        let currentListId = tmpTask.getListId()
                        if currentListId != "" {
                            let listIndex = listStore.allList.firstIndex(where: {$0.getListID() == currentListId})
                            let index = listStore.allList[listIndex!].allTask.firstIndex(where: {$0.getId() == tmpTask.getId()})
                            tmpTask.setListId(listID: list!.getListID())
                            tmpList.allTask.append(tmpTask)
                            listStore.allList[listIndex!].allTask.remove(at: index!)
                        }
                        else{
                            let index = taskStore.allTask.firstIndex(where: {$0.getId() == tmpTask.getId()})
                            if tmpTask.getIsSelected(){
                                tmpTask.setListId(listID: list!.getListID())
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
