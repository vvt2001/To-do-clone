//
//  SelectionTableViewCell.swift
//  To Do Clone
//
//  Created by Vũ Việt Thắng on 08/04/2022.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    
    var taskStore: TaskStore!
    var listStore: ListStore!
    
    let optionList = ["My day","Important","Planned","Assigned to me","Tasks"]
    
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
        self.label.text = option
        switch index{
        case 0:
            self.icon.image = UIImage(systemName: "sun.max")
            if taskStore.myDayUnfinishedTask.count != 0{
                self.taskCount.text = "\(taskStore.myDayUnfinishedTask.count)"
            }
            else{
                self.taskCount.text = ""
            }
        case 1:
            self.icon.image = UIImage(systemName: "star")
            if taskStore.importantTask.count != 0{
                self.taskCount.text = "\(taskStore.importantTask.count)"
            }
            else{
                self.taskCount.text = ""
            }
        case 2:
            self.icon.image = UIImage(systemName: "calendar")
            if taskStore.todayTask.count != 0{
                self.taskCount.text = "\(taskStore.todayTask.count)"
            }
            else{
                self.taskCount.text = ""
            }
        case 3:
            self.icon.image = UIImage(systemName: "person")
            if taskStore.assignedToMeTask.count != 0{
                self.taskCount.text = "\(taskStore.assignedToMeTask.count)"
            }
            else{
                self.taskCount.text = ""
            }
        case 4:
            self.icon.image = UIImage(systemName: "checkmark.icloud")
            if taskStore.normalTask.count != 0{
                self.taskCount.text = "\(taskStore.normalTask.count)"
            }
            else{
                self.taskCount.text = ""
            }
        default:
            break
        }
    }
    
    func createListCell(name: String, index: Int){
        self.label.text = name
        if listStore.allList[index].unfinishedTask.count != 0{
            self.taskCount.text = "\(listStore.allList[index].unfinishedTask.count)"
        }
        else{
            self.taskCount.text = ""
        }
        self.icon.image = UIImage(systemName: "list.bullet")
    }
}
