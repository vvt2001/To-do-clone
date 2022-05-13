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
            if task.dueDate != nil && !task.isFinished{
                tasks.append(task)
            }
        }
        for task in allListedTask{
            if task.dueDate != nil && !task.isFinished{
                tasks.append(task)
            }
        }
        return tasks
    }
    
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
            if task.isMyDay && !task.isFinished{
                myDayUnfinished.append(task)
            }
        }
        for task in allListedTask{
            if task.isMyDay && !task.isFinished{
                myDayUnfinished.append(task)
            }
        }
        return myDayUnfinished
    }
    
    var myDayFinishedTask: [Task]{
        var myDayFinishedTask = [Task]()
        for task in allTask{
            if task.isMyDay && task.isFinished{
                myDayFinishedTask.append(task)
            }
        }
        for task in allListedTask{
            if task.isMyDay && task.isFinished{
                myDayFinishedTask.append(task)
            }
        }
        return myDayFinishedTask
    }
    
//    var plannedTask: [Task]{
//        var planned = [Task]()
//        for task in allTask{
//            if task.type == .planned && !task.isFinished{
//                planned.append(task)
//            }
//        }
//        return planned
//    }
    
    var assignedToMeTask: [Task]{
        var assignedToMe = [Task]()
        for task in allTask{
            if task.type == .assignToMe{
                assignedToMe.append(task)
            }
        }
        for task in allListedTask{
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
    
    var todayTask: [Task]{
        var tasks = [Task]()
        let dueDate = Date()
        for task in allPlannedTask{
            if task.dueDate?.day == dueDate.day && task.dueDate?.monthString == dueDate.monthString{
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
            if task.dueDate?.day == dueDate?.day{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var overdueTask: [Task]{
        var tasks = [Task]()
        let date = Date()
        for task in allPlannedTask{
            if task.dueDate!.day < date.day || task.dueDate!.monthString < date.monthString{
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var thisWeekTask: [Task]{
        var tasks = [Task]()
        for task in allPlannedTask{
            if Calendar.current.isDateInThisWeek(task.dueDate!){
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
            if task.dueDate!.day >= laterDate.day || task.dueDate!.monthString >= laterDate.monthString{
                tasks.append(task)
            }
        }
        return tasks
    }
    
//    @discardableResult func createTask(name: String!, type: taskType, isMyDay: Bool) -> Task{
//        let newTask: Task
//        newTask = Task(name: name, type: type, isMyDay: isMyDay)
//        if newTask.type == .Important{
//            newTask.isImportant = true
//        }
//        allTask.append(newTask)
//        return newTask
//    }
    
    @discardableResult func createTask(name: String!, type: taskType, date: Date?, isMyDay: Bool) -> Task{
        let newTask: Task
        newTask = Task(name: name, type: type, isMyDay: isMyDay)
        newTask.dueDate = date
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
    
//    func moveTask(from fromIndex: Int, to toIndex: Int, task: Task){
//        if fromIndex == toIndex{
//            return
//        }
//        //get reference to object being move so u can reinsert it
//        var movedTask = task
//        if movedTask.isFinished{
//            movedTask = finishedTask[fromIndex]
//            //delete
//            allTask.remove(at: fromIndex)
//            //reinsert
//            finishedTask.insert(movedTask, at: toIndex)
//        }
//        else{
//            movedItem = below50Item[fromIndex]
//            //delete
//            below50Item.remove(at: fromIndex)
//            //reinsert
//            below50Item.insert(movedItem, at: toIndex)
//        }
//    }
    
    func findID(_ task: Task) -> Int{
        var foundIndex = 999
        for (index, tmpTask) in allTask.enumerated(){
            if tmpTask.id == task.id{
                foundIndex = index
            }
        }
        return foundIndex
    }
}

extension Calendar{
    private var currentDate: Date { return Date() }

    func isDateInThisWeek(_ date: Date) -> Bool {
      return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
}
