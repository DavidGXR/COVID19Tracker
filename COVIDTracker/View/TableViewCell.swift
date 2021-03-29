//
//  TableViewCell.swift
//  COVIDTracker
//
//  Created by David Im on 23/3/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var signImageView: UIImageView!
    @IBOutlet weak var newCaseNumberLabel: UILabel!
    @IBOutlet weak var caseTitleLabel: UILabel!
    @IBOutlet weak var caseNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        caseNumberLabel.adjustsFontSizeToFitWidth = true
        caseNumberLabel.minimumScaleFactor = 0.2
        
        newCaseNumberLabel.adjustsFontSizeToFitWidth = true
        newCaseNumberLabel.minimumScaleFactor = 0.2
        
        background.layer.cornerRadius = background.frame.height/8
        
    }
}
