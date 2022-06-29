//
//  List.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import Foundation
import RealmSwift

class List: Object{

    
    @objc dynamic private var name: String = ""
    @objc dynamic private var id = NSUUID().uuidString
    @objc dynamic private var accountID = ""

    var allTask = [Task]()

    override init() {
    }
    
    func getName() -> String
    {
        return self.name
    }
    func setName(newName: String)
    {
        try! Database.realm.write(
            {
                self.name = newName
            }
        )
    }
    func getListID() -> String
    {
        return self.id
    }
    func getAccountID() -> String{
        return self.accountID
    }
    
    func setAccountId(accountID: String){
        try! Database.realm.write({
            self.accountID = accountID
        })
    }
    
    var unfinishedTask: [Task]{
        var unfinished = [Task]()
        for task in allTask{
            if task.getIsFinished() == false{
                unfinished.append(task)
            }
        }
        return unfinished
    }
    var finishedTask: [Task]{
        var finished = [Task]()
        for task in allTask{
            if task.getIsFinished() == true{
                finished.append(task)
            }
        }
        return finished
    }
    var importantTask: [Task]{
        var important = [Task]()
        for task in allTask{
            if task.getIsImportant() == true{
                important.append(task)
            }
        }
        return important
    }
    
    init(name: String){
        self.name = name
    }
    
//    @discardableResult func createTask(name: String!, type: taskType, isMyDay: Bool) -> Task{
//        let newTask: Task
//        newTask = Task(name: name, type: type, isMyDay: isMyDay)
//        allTask.append(newTask)
//        return newTask
//    }
    func createTask(task: Task){
        Database.addTask(newTask: task)
        allTask.append(task)
    }
    func deleteTask(task: Task){
        let index = allTask.firstIndex(where: {$0.getId() == task.getId()})
        allTask.remove(at: index!)
        Database.deleteTask(task: task)
    }
}
