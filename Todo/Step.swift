//
//  Step.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 27/04/2022.
//

import Foundation
import RealmSwift

class Step: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var isFinished: Bool = false
    @objc dynamic private var taskID: String!
    @objc dynamic private var id = NSUUID().uuidString

    override init() {
    }
    
    init (name: String, taskID: String){
        self.name = name
        self.taskID = taskID
    }
    
    func getId() -> String{
        return self.id
    }
    func getTaskID() -> String
    {
        return self.taskID
    }
    func getIsFinished() -> Bool
    {
        return self.isFinished
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
            })
        //self.name = newName

    }
    func setIsFinished(newIsFinished: Bool)
    {
        try! Database.realm.write(
            {
                self.isFinished = newIsFinished
            })
        //self.isFinished = newIsFinished

    }
//    static func ==(lhs: Step, rhs: Step) -> Bool {
//        return lhs.name == rhs.name
//            && lhs.isFinished == rhs.isFinished
//    }
}
