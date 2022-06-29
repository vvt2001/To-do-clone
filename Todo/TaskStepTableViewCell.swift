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
    var task: Task!
    var step: Step!
    var currentIndexPath: IndexPath?
    
    @IBAction func finishedStep(_ sender: UIButton){
        if step.isFinished == false{
            step.setIsFinished(newIsFinished: true)
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else{
            step.setIsFinished(newIsFinished: false)
            self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        delegate?.taskStepTableViewCell(self)
    }
    @IBAction func deleteStep(_ sender: UIButton){
        delegate?.taskStepTableViewCell(self, didSelectDeleteWithStep: step, didSelectDeleteAtIndexPath: currentIndexPath!)
    }
    
    func createCell(task: Task, indexPath: IndexPath){
            currentIndexPath = indexPath
            stepNameField.text = step.name
            if step.isFinished == false{
                self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle")
            }
            else{
                self.finishedButton.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            }
    }
    
    @IBAction func changeStepName(_ sender: UITextField){
        if let stepName = stepNameField.text, !stepName.isEmpty{
            step.setName(newName: stepName)
        }
        else{
            task.deleteStep(step: step)
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
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell, didSelectDeleteWithStep step: Step, didSelectDeleteAtIndexPath indexPath: IndexPath)
    func taskStepTableViewCell(_ cell: TaskStepTableViewCell)
}
