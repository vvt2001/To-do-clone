//
//  Account.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 25/06/2022.
//

import Foundation
import RealmSwift

class Account: Object{
    @objc dynamic private var username: String = ""
    @objc dynamic private var password: String = ""
    @objc dynamic private var isLoggedIn: Bool = false
    @objc dynamic private var id = NSUUID().uuidString
    
    @objc dynamic private var currentThemeTypeRaw: Int = themeType.white.rawValue
    private var currentThemeType: themeType!
    {
        get{
            return themeType(rawValue: currentThemeTypeRaw)
        }
        set
        {
            currentThemeTypeRaw = newValue.rawValue
        }
    }
    
    override init() {
    }
    
    func getUsername() -> String{
        return self.username
    }
    func getPassword() -> String{
        return self.password
    }
    func getIsLoggedIn() -> Bool{
        return self.isLoggedIn
    }
    func getID() -> String{
        return self.id
    }
    func getCurrentThemeType() -> themeType{
        return self.currentThemeType
    }
    
    func setIsLoggedIn(isLoggedIn: Bool){
        try! Database.realm.write({
            self.isLoggedIn = isLoggedIn
        })
    }
    func setCurrentThemeType(currentThemeType: themeType){
        try! Database.realm.write({
            self.currentThemeType = currentThemeType
        })
    }
    
    init(username: String, password: String){
        super.init()
        self.username = username
        self.password = password
    }
}
