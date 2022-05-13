//
//  FilterOptionsTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 20/04/2022.
//

import UIKit

class FilterOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let optionList = ["All Planned","Overdue","Today","Tomorrow","This Week","Later"]
    
    func getThisWeek() -> String{
        let firstDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 6
        let lastDate = Calendar.current.date(byAdding: dateComponent, to: firstDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let firstDay = dateFormatter.string(from: firstDate)
        let lastDay = dateFormatter.string(from: lastDate)
        
        dateFormatter.dateFormat = "MM"
        let firstMonth = dateFormatter.string(from: firstDate)
        let lastMonth = dateFormatter.string(from: lastDate)
        return firstDay + "/" + firstMonth + "-" + lastDay + "/" + lastMonth
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            self.icon.image = UIImage(systemName: "calendar")
        case 1:
            self.icon.image = UIImage(systemName: "calendar.badge.exclamationmark")
        case 2:
            self.icon.image = UIImage(systemName: "calendar.circle")
            self.dateLabel.text = getToday()
        case 3:
            self.icon.image = UIImage(systemName: "calendar.badge.plus")
            self.dateLabel.text = getTomorrow()
        case 4:
            self.icon.image = UIImage(systemName: "calendar.circle.fill")
            self.dateLabel.text = getThisWeek()
        case 5:
            self.icon.image = UIImage(systemName: "calendar.badge.clock")
        default:
            self.dateLabel.text = ""
        }
    }
    
}
