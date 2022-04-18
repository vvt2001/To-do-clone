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
            self.taskCount.text = "\(taskStore.myDayUnfinishedTask.count)"
        case 1:
            self.taskCount.text = "\(taskStore.importantTask.count)"
        case 2:
            self.taskCount.text = "\(taskStore.plannedTask.count)"
        case 3:
            self.taskCount.text = "\(taskStore.assignedToMeTask.count)"
        case 4:
            self.taskCount.text = "\(taskStore.normalTask.count)"
        default:
            self.taskCount.text = ""
        }
//        self.taskCount.text = taskCount
    }
    func createListCell(name: String, index: Int){
        self.label.text = name
        self.taskCount.text = "\(listStore.allList[index].unfinishedTask.count)"
    }
}
