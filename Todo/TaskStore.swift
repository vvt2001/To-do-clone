//
//  TaskStore.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 13/04/2022.
//

import Foundation

class TaskStore{
    var allTask = [Task]()
    var allListedTask = [Task]()
    
    var unfinishedTask: [Task]{
        var unfinished = [Task]()
        for task in allTask{
            if !task.isFinished{
                unfinished.append(task)
            }
        }
        return unfinished
    }
    var finishedTask: [Task]{
        var finished = [Task]()
        for task in allTask{
            if task.isFinished{
                finished.append(task)
            }
        }
        return finished
    }
    var importantTask: [Task]{
        var important = [Task]()
        for task in allTask{
            if task.isImportant && !task.isFinished{
                important.append(task)
            }
        }
        for task in allListedTask{
            if task.isImportant && !task.isFinished{
                important.append(task)
            }
        }
        return important
    }
    
    var myDayUnfinishedTask: [Task]{
        var myDayUnfinished = [Task]()
        for task in allTask{
            if task.type == .myDay && !task.isFinished{
                myDayUnfinished.append(task)
            }
        }
        return myDayUnfinished
    }
    var myDayFinishedTask: [Task]{
        var myDayFinishedTask = [Task]()
        for task in allTask{
            if task.type == .myDay && task.isFinished{
                myDayFinishedTask.append(task)
            }
        }
        return myDayFinishedTask
    }
    
    var plannedTask: [Task]{
        var planned = [Task]()
        for task in allTask{
            if task.type == .planned && !task.isFinished{
                planned.append(task)
            }
        }
        return planned
    }
    var assignedToMeTask: [Task]{
        var assignedToMe = [Task]()
        for task in allTask{
            if task.type == .assignToMe{
                assignedToMe.append(task)
            }
        }
        return assignedToMe
    }
    var normalTask: [Task]{
        var tasks = [Task]()
        for task in allTask{
            if !task.isFinished{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    @discardableResult func createTask(name: String!, type: taskType) -> Task{
        let newTask: Task
        newTask = Task(name: name, type: type)
        if newTask.type == .Important{
            newTask.isImportant = true
        }
        allTask.append(newTask)
        return newTask
    }
    
}
