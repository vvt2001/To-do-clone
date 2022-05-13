//
//  ListSelectorTableViewCell.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 04/05/2022.
//

import UIKit

class ListSelectorTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var listName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createCell(list: List){
        self.listName.text = list.name
        self.icon.image = UIImage(systemName: "list.bullet")
    }
}
