//
//  ListStore.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import Foundation

class ListStore{
    var allList = [List]()
    func setName(name: String){
        
    }
    func createList(list: List){
        Database.addList(newList: list)
        allList.append(list)
    }
    
    func deleteList(list: List){
        if let index = allList.firstIndex(where: {$0.getListID() == list.getListID()}){
            allList.remove(at: index)
        }
        Database.deleteList(list: list)
    }
}
