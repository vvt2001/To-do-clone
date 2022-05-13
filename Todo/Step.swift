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
    
    override init() {
    }
    
    init (name: String){
        self.name = name
    }
//    static func ==(lhs: Step, rhs: Step) -> Bool {
//        return lhs.name == rhs.name
//            && lhs.isFinished == rhs.isFinished
//    }
}
