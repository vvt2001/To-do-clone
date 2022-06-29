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

    var allPlannedTask: [Task]{
        var tasks = [Task]()
        for task in allTask{
            if task.getDueDate() != nil && !task.getIsFinished(){
                tasks.append(task)
            }
        }
        for task in allListedTask{
            if task.getDueDate() != nil && !task.getIsFinished(){
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var unfinishedTask: [Task]{
        var unfinished = [Task]()
        for task in allTask{
            if !task.getIsFinished(){
                unfinished.append(task)
            }
        }
        return unfinished
    }
    var finishedTask: [Task]{
        var finished = [Task]()
        for task in allTask{
            if task.getIsFinished(){
                finished.append(task)
            }
        }
        return finished
    }
    var importantTask: [Task]{
        var important = [Task]()
        for task in allTask{
            if task.getIsImportant() && !task.getIsFinished(){
                important.append(task)
            }
        }
        for task in allListedTask{
            if task.getIsImportant() && !task.getIsFinished(){
                important.append(task)
            }
        }
        return important
    }
    
    var myDayUnfinishedTask: [Task]{
        var myDayUnfinished = [Task]()
        for task in allTask{
            if task.getIsMyDay() && !task.getIsFinished(){
                myDayUnfinished.append(task)
            }
        }
        for task in allListedTask{
            if task.getIsMyDay() && !task.getIsFinished(){
                myDayUnfinished.append(task)
            }
        }
        return myDayUnfinished
    }
    
    var myDayFinishedTask: [Task]{
        var myDayFinishedTask = [Task]()
        for task in allTask{
            if task.getIsMyDay() && task.getIsFinished(){
                myDayFinishedTask.append(task)
            }
        }
        for task in allListedTask{
            if task.getIsMyDay() && task.getIsFinished(){
                myDayFinishedTask.append(task)
            }
        }
        return myDayFinishedTask
    }
    
//    var plannedTask: [Task]{
//        var planned = [Task]()
//        for task in allTask{
//            if task.getType() == .planned && !task.getIsFinished(){
//                planned.append(task)
//            }
//        }
//        return planned
//    }
    
    var assignedToMeTask: [Task]{
        var assignedToMe = [Task]()
        for task in allTask{
            if task.getType() == .assignToMe{
                assignedToMe.append(task)
            }
        }
        for task in allListedTask{
            if task.getType() == .assignToMe{
                assignedToMe.append(task)
            }
        }
        return assignedToMe
    }
    var normalTask: [Task]{
        var tasks = [Task]()
        for task in allTask{
            if !task.getIsFinished(){
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var todayTask: [Task]{
        var tasks = [Task]()
        let dueDate = Date()
        for task in allPlannedTask{
            if task.getDueDate()!.day == dueDate.day && task.getDueDate()!.monthString == dueDate.monthString{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var tomorrowTask: [Task]{
        var tasks = [Task]()
        let date = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let dueDate = Calendar.current.date(byAdding: dateComponent, to: date)
        for task in allPlannedTask{
            if task.getDueDate()!.day == dueDate?.day{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var overdueTask: [Task]{
        var tasks = [Task]()
        let date = Date()
        for task in allPlannedTask{
            if task.getDueDate()!.day < date.day || task.getDueDate()!.monthString < date.monthString{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var thisWeekTask: [Task]{
        var tasks = [Task]()
        for task in allPlannedTask{
            if Calendar.current.isDateInThisWeek(task.getDueDate()!){
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var laterTask: [Task]{
        var tasks = [Task]()
        let date = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 7
        let laterDate = Calendar.current.date(byAdding: dateComponent, to: date)!
        for task in allPlannedTask{
            if task.getDueDate()!.day >= laterDate.day || task.getDueDate()!.monthString >= laterDate.monthString{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    func addTask(task: Task){
        Database.addTask(newTask: task)
        allTask.append(task)
    }
    
    func deleteTask(task: Task){
        let index = allTask.firstIndex(where: {$0.getId() == task.getId()})
        allTask.remove(at: index!)
        Database.deleteTask(task: task)
    }
}

extension Calendar{
    private var currentDate: Date { return Date() }

    func isDateInThisWeek(_ date: Date) -> Bool {
      return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
}
