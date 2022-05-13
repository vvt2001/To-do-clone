//
//  List.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import Foundation

class List: Equatable{
    var name: String
    var allTask = [Task]()
    var id = NSUUID().uuidString
    
    var unfinishedTask: [Task]{
        var unfinished = [Task]()
        for task in allTask{
            if task.isFinished == false{
                unfinished.append(task)
            }
        }
        return unfinished
    }
    var finishedTask: [Task]{
        var finished = [Task]()
        for task in allTask{
            if task.isFinished == true{
                finished.append(task)
            }
        }
        return finished
    }
    var importantTask: [Task]{
        var important = [Task]()
        for task in allTask{
            if task.isImportant == true{
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
    @discardableResult func createTask(name: String!, type: taskType, date: Date?, isMyDay: Bool, listId: String) -> Task{
        let newTask: Task
        newTask = Task(name: name, type: type, isMyDay: isMyDay)
        newTask.dueDate = date
        newTask.listID = listId
        if newTask.type == .Important{
            newTask.isImportant = true
        }
        allTask.append(newTask)
        return newTask
    }
    func deleteTask(_ task: Task){
        let index = findID(task)
        allTask.remove(at: index)
    }
    
    func findID(_ task: Task) -> Int{
        var foundIndex = 999
        for (index, tmpTask) in allTask.enumerated(){
            if tmpTask.id == task.id{
                foundIndex = index
            }
        }
        return foundIndex
    }
    
    static func ==(lhs: List, rhs: List) -> Bool {
        return lhs.name == rhs.name
            && lhs.name == rhs.name
    }
}
