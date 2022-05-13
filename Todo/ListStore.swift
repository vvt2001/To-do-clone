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
    @discardableResult func createList(name: String!) -> List{
        let newList: List
        newList = List(name: name)
        allList.append(newList)
        return newList
    }
    
    func deleteList(_ list: List){
        if let index = allList.firstIndex(of: list){
            allList.remove(at: index)
        }
    }
}
