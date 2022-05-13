//
//  Enumeration.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 20/04/2022.
//

import Foundation

enum taskType: Int{
    case myDay = 1
    case Important
    case planned
    case assignToMe
    case tasks
    case listed
}

enum dueType{
    case today
    case tomorrow
    case nextWeek
    case optional
}

enum themeType{
    case white
    case red
    case blue
    case green
    case yellow
    case purple
    case teal
}
