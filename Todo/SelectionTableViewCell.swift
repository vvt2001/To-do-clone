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
//        self.taskCount.text = taskCount
    }
    func createListCell(name: String, taskCount: String){
        self.label.text = name
        self.taskCount.text = taskCount
    }
}
