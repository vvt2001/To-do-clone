//
//  SortOptionsTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 11/05/2022.
//

import UIKit

class SortOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func createOptionCell(index: Int){
        switch index{
        case 0:
            self.icon.image = UIImage(systemName: "star")
            self.optionLabel.text = "Importance"
        case 1:
            self.icon.image = UIImage(systemName: "arrow.up.arrow.down")
            self.optionLabel.text = "Alphabetically"
        case 2:
            self.icon.image = UIImage(systemName: "calendar")
            self.optionLabel.text = "Due Date"
        case 3:
            self.icon.image = UIImage(systemName: "sun.min")
            self.optionLabel.text = "Added to My Day"
        default:
            break
        }
    }
}
