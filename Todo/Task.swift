//
//  Task.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 13/04/2022.
//

import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var isFinished: Bool = false
    @objc dynamic var isImportant: Bool = false
//    @objc dynamic var type: taskType
    
    @objc dynamic var privateType: Int = taskType.myDay.rawValue
    var type: taskType {
        get { return taskType(rawValue: privateType)! }
        set { privateType = newValue.rawValue }
    }
    
    @objc dynamic var dueDate: Date?
    var steps: [(Step)] = []
    @objc dynamic var isMyDay: Bool = false
    @objc dynamic var listID = ""
    @objc dynamic var isSelected: Bool = false
    
    override init() {
    }
    
    init(name: String, type: taskType, isMyDay: Bool){
        self.name = name
        self.isMyDay = isMyDay
        super.init()
        self.type = type
    }
    
    func createStep(name: String){
        let step = Step(name: name)
        steps.append(step)
    }
    func deleteStep(index: Int){
        steps.remove(at: index)
    }
//    static func ==(lhs: Task, rhs: Task) -> Bool {
//        return lhs.name == rhs.name
//    }
}
