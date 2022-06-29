//
//  ModifyOptionTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class ModifyOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
            
    func createCell(task: Task, index: Int){
        switch index{
        case 0:
            if task.getIsMyDay(){
                self.icon.image = UIImage(systemName: "sun.max.fill")
                self.optionLabel.text = "Added to My Day"
            }
            else{
                self.icon.image = UIImage(systemName: "sun.max")
                self.optionLabel.text = "Add to My Day"

            }
        case 1:
            if task.getRemindId() != ""{
                self.icon.image = UIImage(systemName: "bell.fill")
                if task.getDueDate() == nil{
                    self.optionLabel.text = "Remind Me Today"
                }
                else{
                    self.optionLabel.text = "Remind Me before Due"
                }
            }
            else {
                self.icon.image = UIImage(systemName: "bell")
                self.optionLabel.text = "Remind Me"
            }
        case 2:
            if task.getDueDate() == nil{
                self.icon.image = UIImage(systemName: "calendar.circle")
                self.optionLabel.text = "Add Due Date"
            }
            else{
                self.icon.image = UIImage(systemName: "calendar.circle.fill")
                let due = task.getDueDate()!.date
                self.optionLabel.text = "Due " + due
            }
        case 3:
            self.icon.image = UIImage(systemName: "pencil")
            if task.getNote() == ""{
                self.optionLabel.text = "Add Note"
            }
            else {
                self.optionLabel.text = task.getNote()
            }
        default:
            break
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
    
}

extension ModifyOptionTableViewCell: TaskModificationViewControllerDelegate{
    func taskModificationViewController(_ viewController: UIViewController, didTapAddDueDateWithDue due: Date?, didTapAddDueDateWithIndex index: Int) {
        var dueDate = String()
        let cell = DueTableViewCell()
        let nextWeekDate = cell.getNextWeek()
        
        switch index{
        case 0:
            dueDate = " Today"
        case 1:
            dueDate = " Tomorrow"
        case 2:
            dueDate = " " + nextWeekDate!
        case 3:
            if due != nil{
                dueDate = " " + due!.date
            }
        default:
            break
        }
        
        if due != nil{
            let dueString = "Due" + dueDate
            self.optionLabel.text = dueString
        }
    }
}
