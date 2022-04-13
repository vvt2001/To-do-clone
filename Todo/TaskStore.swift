//
//  TaskStore.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 13/04/2022.
//

import Foundation

class TaskStore{
    var allTask = [Task]()
    var unfinishedTask = [Task]()
    var finishedTask = [Task]()
    var importantTask = [Task]()
    
    @discardableResult func createTask(name: String!) -> Task{
        let newTask: Task
        newTask = Task(name: name)
        allTask.append(newTask)
        unfinishedTask.append(newTask)
        return newTask
    }
    
}
