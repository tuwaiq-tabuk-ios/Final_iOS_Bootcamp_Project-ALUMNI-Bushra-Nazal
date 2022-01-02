//
//  MessageCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit

class MessageCell: UITableViewCell {

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var messageViewLeft: NSLayoutConstraint!
  @IBOutlet weak var messageViewRight: NSLayoutConstraint!
  @IBOutlet weak var messageTime: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      messageView.layer.cornerRadius = 8
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
