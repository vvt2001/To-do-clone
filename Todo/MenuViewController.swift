//
//  ViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class MenuViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var username: UILabel!
    @IBOutlet var selectionTable: UITableView!
    @IBOutlet var newList: UIButton!
    @IBOutlet var addListField: UITextField!
    
    var listStore = ListStore()
    var taskStore = TaskStore()
    var account: Account!
//    var listArr = [List]()
    
    @IBAction func addList(_ sender: UIButton){
        if let listName = addListField.text, !listName.isEmpty{
            let newList = List(name: listName)
            newList.setAccountId(accountID: account.getID())
            listStore.createList(list: newList)
            var indexPath = IndexPath()
            if let index = listStore.allList.lastIndex(where: {$0.getListID() == newList.getListID()}){
                indexPath = IndexPath(row: index, section: 1)
            }
            selectionTable.insertRows(at: [indexPath], with: .automatic)
            addListField.text = .none
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func initDatabase()
    {
        let noteTasks = Database.realm.objects(Task.self)
        let lists = Database.realm.objects(List.self)
        let steps = Database.realm.objects(Step.self)
        
        for value in lists
        {
            if value.getAccountID() == account.getID(){
                listStore.allList.append(value)
            }
        }
        for value in noteTasks
        {
            if value.getAccountID() == account.getID(){
                //add steps
                for step in steps
                {
                    if(step.getTaskID() == value.getId())
                    {
                        value.steps.append(step)
                    }
                }
                //add to store
                if(value.getType() != .listed)
                {
                    taskStore.allTask.append(value)
                }
                else
                {
                    taskStore.allListedTask.append(value)
                    for list in listStore.allList
                    {
                        if(value.getListId() == list.getListID())
                        {
                            list.allTask.append(value)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func showLogOutAlert(){
        let title = "Log out"
        let message = "Are you sure you want to log out"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
            self.account.setIsLoggedIn(isLoggedIn: false)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {_ in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDatabase()
        username.text = account.getUsername()
        selectionTable.delegate = self
        selectionTable.dataSource = self
        self.selectionTable.register(UINib(nibName: "SelectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectionTableViewCell")
        
        selectionTable.rowHeight = 60
        //selectionTable.estimatedRowHeight = 60
        
        self.title = "Welcome"
        
        var logOutBarButtonItem = UIBarButtonItem()
        logOutBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(showLogOutAlert))
        self.navigationItem.leftBarButtonItem = logOutBarButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectionTable.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        isMoved = true
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin
        bottomConstraint.constant = 0
        isMoved = false
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath) as! SelectionTableViewCell
        cell.taskStore = taskStore
        cell.listStore = listStore
        
        if indexPath.section == 0{
            cell.createOptionCell(index: indexPath.row)
        }
        else{
            cell.createListCell(name: listStore.allList[indexPath.row].getName(), index: indexPath.row)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        else{
            return listStore.allList.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                let myDayViewController = MyDayViewController()
//                let taskStore = TaskStore()
                myDayViewController.taskStore = taskStore
                myDayViewController.listStore = listStore
                myDayViewController.account = account
                
                navigationController?.pushViewController(myDayViewController, animated: true)
            case 1:
                let importantViewController = ImportantViewController()
                importantViewController.taskStore = taskStore
                importantViewController.listStore = listStore
                importantViewController.account = account
                
                navigationController?.pushViewController(importantViewController, animated: true)
            case 2:
                let plannedViewController = PlannedViewController()
                plannedViewController.taskStore = taskStore
                plannedViewController.listStore = listStore
                plannedViewController.account = account
                
                navigationController?.pushViewController(plannedViewController, animated: true)
            case 3:
                let tasksViewController = TasksViewController()
                tasksViewController.taskStore = taskStore
                tasksViewController.listStore = listStore
                tasksViewController.account = account
                
                navigationController?.pushViewController(tasksViewController, animated: true)
            default:
                break
            }
        }
        else{
            let listViewController = ListViewController()
            listViewController.listStore = listStore
            listViewController.list = listStore.allList[indexPath.row]
            listViewController.taskStore = taskStore
            listViewController.account = account
            navigationController?.pushViewController(listViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            if !listStore.allList.isEmpty{
                return "Lists"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let list = listStore.allList[indexPath.row]
            for task in taskStore.allListedTask{
                if task.getListId() == list.getListID(){
                    if let index = taskStore.allListedTask.firstIndex(where: {$0.getId() == task.getId()}){
                        taskStore.allListedTask.remove(at: index)
                    }
                    list.deleteTask(task: task)
                }
            }
            listStore.deleteList(list: list)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
