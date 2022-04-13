//
//  TaskTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 13/04/2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    //create delegate
    var delegate: TaskTableViewCellDelegate?
    
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var importantButton: UIButton!
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskType: UILabel!
    
    var task: Task!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func changeFinished(_ sender: UIButton){
        finishedButton.imageView?.image = UIImage(named: "finishChecked")
        //call function for view controller to do
        //equal to viewcontroller.(func)
        delegate?.taskTableViewCell(self, didTapFinishButtonWithTask: task, didTapFinishButtonWithState: true)
        print("pressed")
    }
    @IBAction func changeImportant(_ sender: UIButton){
        finishedButton.imageView?.image = UIImage(named: "importantChecked")
        delegate?.taskTableViewCell(self, didTapImportantButtonWithTask: task, didTapImportantButtonWithState: true)
    }
    
    func createCell(name: String){
        self.taskName.text = name
        
    }
    

}
//create protocol to modify table through cell's button
//cell can't modify table on it's own, and view controller can't access button functions on the cells
protocol TaskTableViewCellDelegate {
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task, didTapFinishButtonWithState state: Bool)
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task, didTapImportantButtonWithState state: Bool)
//    func taskTableViewCellDidTapFinishButton(_ cell: TaskTableViewCell)
//    func taskTableViewCell(didTapFinishButton cell: TaskTableViewCell)
}
