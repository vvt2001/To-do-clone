//
//  DueTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class DueTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let optionList = ["Today","Tomorrow","Next Week","Pick a Date"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getToday() -> String? {
        
        let weekDays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let myDate = dateFormatter.date(from: dateFormatter.string(from: date)) else { return nil }
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: myDate)
        
        
        return weekDays[weekDay-1]
    }
    
    func getTomorrow() -> String? {
        
        let weekDays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let myDate = dateFormatter.date(from: dateFormatter.string(from: date)) else { return nil }
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: myDate)
        
        if weekDay == 7 {
            return "Sunday"
        }
        else{
            return weekDays[weekDay]
        }
    }
    
    func getNextWeek() -> String?{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let myDate = dateFormatter.date(from: dateFormatter.string(from: date)) else { return nil }
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: myDate)
        
        var dateComponent = DateComponents()
        if weekDay == 1{
            dateComponent.day = 1
        }
        else{
            dateComponent.day = 9 - weekDay
        }
        let dueDate = Calendar.current.date(byAdding: dateComponent, to: date)!

        dateFormatter.dateFormat = "dd/MM"
        let due = dateFormatter.string(from: dueDate)
        return "Mon, " + due
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createOptionCell(index: Int){
        let option = optionList[index]
        self.optionsLabel.text = option
        switch index{
        case 0:
            self.icon.image = UIImage(systemName: "calendar.circle")
            self.dateLabel.text = getToday()
        case 1:
            self.icon.image = UIImage(systemName: "calendar.badge.plus")
            self.dateLabel.text = getTomorrow()
        case 2:
            self.icon.image = UIImage(systemName: "calendar.circle.fill")
            self.dateLabel.text = getNextWeek()
        case 3:
            self.icon.image = UIImage(systemName: "calendar")
        default:
            break
        }
    }
}
