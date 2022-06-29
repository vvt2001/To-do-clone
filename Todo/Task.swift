//
//  Task.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 13/04/2022.
//

import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic private var id = NSUUID().uuidString
    @objc dynamic private var name: String = ""
    @objc dynamic private var isFinished: Bool = false
    @objc dynamic private var isImportant: Bool = false
    @objc dynamic private var dueDate: Date?
    var steps: [(Step)] = []
    @objc dynamic private var isMyDay: Bool = false
    @objc dynamic private var listID = ""
    @objc dynamic private var accountID = ""
    @objc dynamic private var isSelected: Bool = false
    @objc dynamic private var note = ""
    @objc dynamic private var createDate: Date = Date()
    @objc dynamic private var remindId: String = ""

    override init() {
    }
    
    @objc dynamic private var taskTypeRaw: Int = taskType.tasks.rawValue
    private var type: taskType!
    {
        get{
            return taskType(rawValue: taskTypeRaw)
        }
        set
        {
            taskTypeRaw = newValue.rawValue
        }
    }
    
    func getId() -> String{
        return self.id
    }
    func getName() -> String{
        return self.name
    }
    func getIsFinished() -> Bool{
        return self.isFinished
    }
    func getIsSelected() -> Bool{
        return self.isSelected
    }
    func getIsImportant() -> Bool{
        return self.isImportant
    }
    func getDueDate() -> Date?{
        if self.dueDate != nil{
            return self.dueDate
        }
        else{
            return nil
        }
    }
    func getIsMyDay() -> Bool{
        return self.isMyDay
    }
    func getListId() -> String{
        return self.listID
    }
    func getAccountID() -> String{
        return self.accountID
    }
    func getNote() -> String{
        return self.note
    }
    func getCreateDate() -> Date{
        return self.createDate
    }
    func getRemindId() -> String{
        return self.remindId
    }
    
    func setName(name: String){
        try! Database.realm.write({
            self.name = name
        })
    }
    func setIsFinished(isFinished: Bool){
        try! Database.realm.write({
            self.isFinished = isFinished
        })
    }
    func setIsSelected(isSelected: Bool){
        try! Database.realm.write({
            self.isSelected = isSelected
        })
    }
    func setIsImportant(isImportant: Bool){
        try! Database.realm.write({
            self.isImportant = isImportant
        })
    }
    func setIsMyDay(isMyDay: Bool){
        try! Database.realm.write({
            self.isMyDay = isMyDay
        })
    }
    func setDueDate(dueDate: Date?){
        try! Database.realm.write({
            self.dueDate = dueDate
        })
    }
    func setListId(listID: String){
        try! Database.realm.write({
            self.listID = listID
        })
    }
    func setAccountId(accountID: String){
        try! Database.realm.write({
            self.accountID = accountID
        })
    }
    func setNote(note: String){
        try! Database.realm.write({
            self.note = note
        })
    }
    func setRemindId(remindId: String){
        try! Database.realm.write({
            self.remindId = remindId
        })
    }
    
    init(name: String, type: taskType, isMyDay: Bool){
        super.init()
        self.name = name
        self.isMyDay = isMyDay
        self.type = type
        if type == .Important{
            setIsImportant(isImportant: true)
        }
    }
    
    func getType() -> taskType{
        return self.type
    }
    func setType(type: taskType){
        try! Database.realm.write({
            self.type = type
        })
    }
    
    func createStep(step: Step){
        Database.addStep(newStep: step)
        steps.append(step)
    }
    func deleteStep(step: Step){
        if let index = steps.firstIndex(where: {$0.getId() == step.getId()}) {
            steps.remove(at: index)
            Database.deleteStep(step: step)
        }
    }
}
