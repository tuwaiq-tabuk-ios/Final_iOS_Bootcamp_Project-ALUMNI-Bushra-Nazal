//
//  MessageCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewLeft: NSLayoutConstraint!
    @IBOutlet weak var messageViewRight: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageView.layer.cornerRadius = 8
    }

  
    
}
