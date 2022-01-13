//
//  CommentCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 30/05/1443 AH.
//

import UIKit

class CommentCell: UITableViewCell {
  
  //MARK: - IBOutlets
  @IBOutlet weak var commentUserAvatar: UIImageView!
  @IBOutlet weak var commentUserNameLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var commentDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      commentUserAvatar.layer.cornerRadius = 15
      commentUserAvatar.layer.borderWidth = 1
      commentUserAvatar.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
