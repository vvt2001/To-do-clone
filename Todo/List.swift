//
//  List.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import Foundation

class List: Equatable{
    var name: String
    var unfinishedTask = [Task]()
    var finishedTask = [Task]()
    var importantTask = [Task]()
    
    init(name: String){
        self.name = name
    }
    
    @discardableResult func createTask(name: String!) -> Task{
        let newTask: Task
        newTask = Task(name: name)
        unfinishedTask.append(newTask)
        return newTask
    }
    
    static func ==(lhs: List, rhs: List) -> Bool {
        return lhs.name == rhs.name
            && lhs.name == rhs.name
    }
}
