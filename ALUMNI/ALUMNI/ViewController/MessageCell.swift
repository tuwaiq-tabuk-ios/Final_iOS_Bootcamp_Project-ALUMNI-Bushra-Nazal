//
//  MessageCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 22/05/1443 AH.
//

import UIKit

class MessageCell: UITableViewCell {

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var messageBubble: UIView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  enum sender {
    case me
    case other
  }

  func getMessageDesign(sender: sender){
    var backGroundColor: UIColor?
    
    switch sender {
    case .me:
      backGroundColor = .white
      messageBubble.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMaxYCorner]
      textLabel?.textAlignment = .right
    case .other:
      backGroundColor = .white
      messageBubble.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
      textLabel?.textAlignment = .left
    default:
     break
    }
    
    messageBubble.backgroundColor = backGroundColor
    messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 2.5
    messageBubble.layer.shadowOpacity = 0.1
  }
}