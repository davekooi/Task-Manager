//
//  ProjectDetailsTableViewCell.swift
//  Project_Manager_Single_View_Start
//
//  Created by David Kooistra on 5/30/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ProjectDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var extraInfo: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
