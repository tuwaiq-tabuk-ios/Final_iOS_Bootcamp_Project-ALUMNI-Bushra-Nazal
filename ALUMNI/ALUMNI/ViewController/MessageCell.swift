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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    messageBubble.frame
    = messageBubble.frame.inset(by: UIEdgeInsets(top: 5,
                                                 left: 10,
                                                 bottom: 5,
                                                 right: 10))
  }
  
  
  enum sender {
    case me
    case other
  }

  func getMessageDesign(sender: sender){
    var backGroundColor: UIColor?
    
    switch sender {
    case .me:
      backGroundColor = .gray
      messageBubble.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMaxYCorner]
      textLabel?.textAlignment = .right
    case .other:
      backGroundColor = .gray
      messageBubble.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
      textLabel?.textAlignment = .left
    default:
     break
    }
    
    messageBubble.backgroundColor = backGroundColor
    messageBubble.layer.cornerRadius = 30
    messageBubble.layer.shadowOpacity = 0.1
  }
}
