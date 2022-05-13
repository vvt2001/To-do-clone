//
//  ViewController.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var email: UILabel!
    @IBOutlet var selectionTable: UITableView!
    @IBOutlet var newList: UIButton!
    @IBOutlet var addListField: UITextField!
    
    var listStore: ListStore!
    let taskStore = TaskStore()
//    var listArr = [List]()
    
    @IBAction func addList(_ sender: UIButton){
        if let taskName = addListField.text, !taskName.isEmpty{
            let newList = listStore.createList(name: addListField.text)
            var indexPath = IndexPath()
            
            if let index = listStore.allList.lastIndex(of: newList){
                indexPath = IndexPath(row: index, section: 1)
            }
            selectionTable.insertRows(at: [indexPath], with: .automatic)
//            listArr.append(newList)
            addListField.text = .none
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        email.text = "thangvv@solarapp.asia"
        selectionTable.delegate = self
        selectionTable.dataSource = self
        self.selectionTable.register(UINib(nibName: "SelectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectionTableViewCell")
        
        selectionTable.rowHeight = 60
        //selectionTable.estimatedRowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectionTable.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath) as! SelectionTableViewCell
        cell.taskStore = taskStore
        cell.listStore = listStore
        
        if indexPath.section == 0{
            cell.createOptionCell(index: indexPath.row)
        }
        else{
            cell.createListCell(name: listStore.allList[indexPath.row].name, index: indexPath.row)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 5
        }
        else{
            return listStore.allList.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                let myDayViewController = MyDayViewController(nibName: "MyDayViewController", bundle: .main)
//                let taskStore = TaskStore()
                myDayViewController.taskStore = taskStore
                myDayViewController.listStore = listStore
                
                navigationController?.pushViewController(myDayViewController, animated: true)
            case 1:
                let importantViewController = ImportantViewController(nibName: "ImportantViewController", bundle: .main)
                importantViewController.taskStore = taskStore
                importantViewController.listStore = listStore
                
                navigationController?.pushViewController(importantViewController, animated: true)
            case 2:
                let plannedViewController = PlannedViewController(nibName: "PlannedViewController", bundle: .main)
                plannedViewController.taskStore = taskStore
                plannedViewController.listStore = listStore
                
                navigationController?.pushViewController(plannedViewController, animated: true)
            case 4:
                let tasksViewController = TasksViewController(nibName: "TasksViewController", bundle: .main)
                tasksViewController.taskStore = taskStore
                tasksViewController.listStore = listStore
                
                navigationController?.pushViewController(tasksViewController, animated: true)
            default:
                break
            }
        }
        else{
            let listViewController = ListViewController(nibName: "ListViewController", bundle: .main)
            listViewController.listStore = listStore
            listViewController.list = listStore.allList[indexPath.row]
            listViewController.taskStore = taskStore
            navigationController?.pushViewController(listViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        else{
            return "Lists"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let list = listStore.allList[indexPath.row]
            listStore.deleteList(list)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
