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
        if let listName = name{
            newList = List(name: listName)
        }
        else{
            if allList.count == 0{
                newList = List(name: "Untitled list")
            }
            else{
                newList = List(name: "Untitled list \(allList.count)")
            }
        }
        allList.append(newList)
        return newList
    }
}
