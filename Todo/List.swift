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
    
    @discardableResult func createTask(name: String!, type: taskType) -> Task{
        let newTask: Task
        newTask = Task(name: name, type: type)
        allTask.append(newTask)
        return newTask
    }
    
    static func ==(lhs: List, rhs: List) -> Bool {
        return lhs.name == rhs.name
            && lhs.name == rhs.name
    }
}
