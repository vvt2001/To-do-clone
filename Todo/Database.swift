//
//  Database.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 15/06/2022.
//

import Foundation
import RealmSwift
class Database
{
    static var realm: Realm!
    static func addTask(newTask: Task){
        try! Database.realm.write{
            Database.realm.add(newTask)
        }
    }
    static func addStep(newStep: Step){
        try! Database.realm.write{
            Database.realm.add(newStep)
        }
    }
    static func deleteStep(step: Step){
        try! Database.realm.write{
            Database.realm.delete(step)
        }
    }
    static func deleteTask(task: Task){
        //delete all steps belong to this task
        for value in task.steps{
            Database.deleteStep(step: value)
        }
        try! Database.realm.write{
            Database.realm.delete(task)
        }
    }
    static func deleteList(list: List){
        for value in list.allTask
        {
            Database.deleteTask(task: value)
        }
        try! Database.realm.write{
            Database.realm.delete(list)
        }
    }
    static func addList(newList: List){
        try! Database.realm.write{
            Database.realm.add(newList)
        }
    }
    static func addAccount(newAccount: Account){
        try! Database.realm.write{
            Database.realm.add(newAccount)
        }
    }
}
