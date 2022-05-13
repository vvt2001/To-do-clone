//
//  TaskStepTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class TaskStepTableViewCell: UITableViewCell {
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var stepNameField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: TaskStepTableViewCellDelegate?
    var step: String!
    var currentIndex: IndexPath?
    var task: Task!
    
    @IBAction func finishedStep(_ sender: UIButton){
        if task.steps[currentIndex!.row].isFinished == false{
            task.steps[currentIndex!.row].isFinished = true
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else{
            task.steps[currentIndex!.row].isFinished = false
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        delegate?.taskStepTableViewCell(self)
    }
    @IBAction func deleteStep(_ sender: UIButton){
        delegate?.taskStepTableViewCell(self, didSelectDeleteAtIndexPath: currentIndex!)
    }
    
    func createCell(task: Task, index: IndexPath){
            currentIndex = index
            stepNameField.text = task.steps[index.row].name
            if task.steps[currentIndex!.row].isFinished == false{
                self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
            }
            else{
                self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            }
    }
    
    @IBAction func changeStepName(_ sender: UITextField){
        if let stepName = stepNameField.text, !stepName.isEmpty{
            task.steps[currentIndex!.row].name = stepName
        }
        else{
            task.deleteStep(index: currentIndex!.row)
            delegate?.taskStepTableViewCell(self)
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

protocol TaskStepTableViewCellDelegate{
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell, didSelectDeleteAtIndexPath indexPath: IndexPath)
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell)
}
