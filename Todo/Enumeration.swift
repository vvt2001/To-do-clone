//
//  Enumeration.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 20/04/2022.
//

import Foundation
import UIKit

enum taskType: Int{
    case myDay
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

enum themeType: Int{
    case white
    case red
    case blue
    case green
    case yellow
    case purple
    case teal
}
