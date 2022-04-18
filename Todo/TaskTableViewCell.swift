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
//        if self.finishedButton.imageView?.image == UIImage(systemName: "checkmark.circle"){
//            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
//        }
//        else {
//            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
//        }
        //call function for view controller to do
        //equal to viewcontroller.(func)
        delegate?.taskTableViewCell(self, didTapFinishButtonWithTask: task)
    }
    @IBAction func changeImportant(_ sender: UIButton){
        if self.importantButton.imageView?.image == UIImage(systemName: "star"){
            self.importantButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else{
            self.importantButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        delegate?.taskTableViewCell(self, didTapImportantButtonWithTask: task)
    }
    
    func createCell(name: String){
        self.taskName.text = name
        if task.isFinished{
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else{
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        if task.isImportant{
            self.importantButton.imageView?.image = UIImage(systemName: "star.fill")
        }
        else{
            self.importantButton.imageView?.image = UIImage(systemName: "star")
        }
    }
    

}
//create protocol to modify table through cell's button
//cell can't modify table on it's own, and view controller can't access button functions on the cells
protocol TaskTableViewCellDelegate {
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapFinishButtonWithTask task: Task)
    func taskTableViewCell(_ cell: TaskTableViewCell, didTapImportantButtonWithTask task: Task)
//    func taskTableViewCellDidTapFinishButton(_ cell: TaskTableViewCell)
//    func taskTableViewCell(didTapFinishButton cell: TaskTableViewCell)
}
