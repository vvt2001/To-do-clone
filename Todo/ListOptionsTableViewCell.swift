//
//  ListOptionsTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 04/05/2022.
//

import UIKit

class ListOptionsTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionName: UILabel!
        
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
            self.icon.image = UIImage(systemName: "pencil")
            self.optionName.text = "Edit"
        case 1:
            self.icon.image = UIImage(systemName: "list.bullet.indent")
            self.optionName.text = "Sort"
        case 2:
            self.icon.image = UIImage(systemName: "sparkles.square.fill.on.square")
            self.optionName.text = "Change Theme"
        case 3:
            self.icon.image = UIImage(systemName: "circlebadge.2")
            self.optionName.text = "Duplicate List"
        default:
            break
        }
    }
}
