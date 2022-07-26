//
//  MyDayViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class ListViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {

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
    var account: Account!

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
            let newTask = Task(name: taskName, type: .listed, isMyDay: false)
            newTask.setListId(listID: list.getListID())
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
            list.createTask(task: newTask)
            taskStore.allListedTask.append(newTask)
            
            var indexPath = IndexPath()
            if let index = list.unfinishedTask.lastIndex(where: {$0.getId() == newTask.getId()}){
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
            if list.unfinishedTask.count > 0{
                for i in 0...(list.unfinishedTask.count - 1){
                    list.unfinishedTask[i].setIsSelected(isSelected: true)
                }
            }
            if list.finishedTask.count > 0{
                for i in 0...(list.finishedTask.count - 1){
                    list.finishedTask[i].setIsSelected(isSelected: true)
                }
            }
            selectAllButton.setTitle("Clear all", for: .normal)
        }
        else{
            isSelected = false
            isSelectedAll = false
            if list.unfinishedTask.count > 0{
                for i in 0...(list.unfinishedTask.count - 1){
                    list.unfinishedTask[i].setIsSelected(isSelected: false)
                }
            }
            if list.finishedTask.count > 0{
                for i in 0...(list.finishedTask.count - 1){
                    list.finishedTask[i].setIsSelected(isSelected: false)
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
            for tmpTask in list.allTask{
                let index = list.allTask.firstIndex(where: {$0.getId() == tmpTask.getId()})
                if tmpTask.getIsSelected(){
                    list.allTask.remove(at: index!)
                }
            }
            taskTable.reloadSections([0, 1], with: .automatic)
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
            taskTable.reloadSections([0, 1], with: .automatic)
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
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        changeTheme(type: account.getCurrentThemeType())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        changeTheme(type: account.getCurrentThemeType())
        self.taskTable.reloadSections([0, 1], with: .automatic)
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
        listOptionsViewController.isDuplicatable = true
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
        cell.selectionStyle = .none
        
        if indexPath.section == 0{
            cell.task = list.unfinishedTask[indexPath.row]
            cell.createCell(name: list.unfinishedTask[indexPath.row].getName())
        }
        else{
            cell.task = list.finishedTask[indexPath.row]
            cell.createCell(name: list.finishedTask[indexPath.row].getName())
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
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
            let index = taskStore.allListedTask.firstIndex(where: {$0.getId() == task.getId()})
            for step in task.steps{
                task.deleteStep(step: step)
            }
            taskStore.allListedTask.remove(at: index!)
            list.deleteTask(task: task)
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
extension ListViewController: TaskTableViewCellDelegate{
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task) {
        let state = task.getIsFinished()
        if state == false{
            task.setIsFinished(isFinished: true)
        }
        else{
            task.setIsFinished(isFinished: false)
        }
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task) {
        let state = task.getIsImportant()
        if state == false{
            for tmpTask in list.allTask {
                if tmpTask.getId() == task.getId(){
                    task.setIsImportant(isImportant: true)
                }
            }
        }
        else{
            for tmpTask in list.allTask {
                if tmpTask.getId() == task.getId(){
                    task.setIsImportant(isImportant: false)
                }
            }
        }
        taskTable.reloadSections([0, 1], with: .automatic)
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
        for tmpTask in taskStore.unfinishedTask{
            if tmpTask.getIsSelected(){
                isSelected = true
                selectedArr?.append(tmpTask)
            }
        }
        for tmpTask in taskStore.finishedTask{
            if tmpTask.getIsSelected(){
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
            taskTable.reloadSections([0, 1], with: .automatic)
        }
    }
}

// MARK: - TaskModificationViewControllerDelegate
extension ListViewController: TaskModificationViewControllerDelegate{
    func taskModificationViewControllerDidChangeTask(_ viewController: UIViewController) {
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    func taskModificationViewController(_ viewController: UIViewController, didTapDeleteWithTask task: Task) {
        for step in task.steps{
            task.deleteStep(step: step)
        }
        let index = taskStore.allListedTask.firstIndex(where: {$0.getId() == task.getId()})
        taskStore.allListedTask.remove(at: index!)
        list.deleteTask(task: task)
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
                list.unfinishedTask[i].setIsSelected(isSelected: false)
            }
        }
        if list.finishedTask.count > 0{
            for i in 0...(list.finishedTask.count - 1){
                list.finishedTask[i].setIsSelected(isSelected: false)
            }
        }
        selectAllButton.setTitle("Select all", for: .normal)
        let attributeText = NSMutableAttributedString(string: selectAllButton.title(for: .normal) ?? "", attributes: [.font: UIFont.systemFont(ofSize: 12.0)])
        selectAllButton.setAttributedTitle(attributeText, for: .normal)

        self.view.layer.opacity = 1.0
        taskTable.reloadSections([0,1], with: .automatic)
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
        taskTable.reloadSections([0,1], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtChangeTheme bool: Bool, didSelectThemeWithType type: themeType) {
        account.setCurrentThemeType(currentThemeType: type)
        changeTheme(type: type)
        self.view.layer.opacity = 1.0
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDuplicateList bool: Bool) {
        let newList = List(name: list.getName())
        newList.setAccountId(accountID: account.getID())
        listStore.createList(list: newList)
        for tmpTask in self.list.allTask{
            tmpTask.setListId(listID: newList.getListID())
            newList.allTask.append(tmpTask)
        }
        self.view.layer.opacity = 1.0
        taskTable.reloadSections([0, 1], with: .automatic)
    }
    
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTable.reloadData()
    }
}

// MARK: - ListSelectorViewControllerDelegate
extension ListViewController: ListSelectorViewControllerDelegate{
    func listSelectorViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        self.view.layer.opacity = opacity
        self.taskTable.reloadData()
    }
    
    func listSelectorViewController(_ viewController: UIViewController, selectForListOptions bool: Bool, listForIndex list: List?) {
        for tmpList in listStore.allList{
            if tmpList.getListID() == list?.getListID(){
                
                for tmpTask in self.list.allTask{
                    if tmpTask.getIsSelected(){
                        let index = self.list.allTask.firstIndex(where: {$0.getId() == tmpTask.getId()})
                        tmpTask.setListId(listID: list!.getListID())
                        tmpList.allTask.append(tmpTask)
                        self.list.allTask.remove(at: index!)
                    }
                }
        
            }
        }
        self.view.layer.opacity = 1.0
        taskTable.reloadSections([0, 1], with: .automatic)
    }
     
    func listSelectorViewController(_ viewController: UIViewController, selectForAddTask bool: Bool, listForIndex list: List?) {
        
    }
}


