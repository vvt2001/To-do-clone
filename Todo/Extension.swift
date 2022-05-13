//
//  Extension.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 20/04/2022.
//

import Foundation

extension Date {
    var dayofTheWeek: String {
          let dayNumber = Calendar.current.component(.weekday, from: self)
          // day number starts from 1 but array count from 0
          return daysOfTheWeek[dayNumber - 1]
     }
    var day: String
    {
        let dayCount: Int = Calendar.current.component(.day, from: self)
        return "\(dayCount)"
    }
    var week: Int
    {
        let weekCount: Int = Calendar.current.component(.yearForWeekOfYear, from: self)
        return weekCount
    }
    var monthString: String
    {
        let monthCount = Calendar.current.component(.weekday, from: self)
        // day number starts from 1 but array count from 0
        return monthsCount[monthCount - 1]
    }
     private var daysOfTheWeek: [String] {
          return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
     }
    var dayOfTheWeekByInt: Int
    {
        return Calendar.current.component(.weekday, from: self)
    }
    private var monthsCount: [String] {
         return  ["January", "February", "March", "April", "May", "July", "June", "August", "September", "October", "November", "December"]
    }
    var date: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.string(from: self)
        return date
    }
  }
