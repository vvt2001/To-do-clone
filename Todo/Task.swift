//
//  Task.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 13/04/2022.
//

import Foundation

class Task: Equatable{
    var id = NSUUID().uuidString
    var name: String
    var isFinished: Bool = false
    var isImportant: Bool = false
    
    init(name: String){
        self.name = name
    }
    
    enum type{
        case myDay
        case Important
        case planned
        case assignToMe
        case tasks
    }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.name == rhs.name
            && lhs.name == rhs.name
    }
}
