//
//  PostCellTableViewCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {
  
  
  
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var postLabel: UILabel!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var likeLabel: UILabel!
  
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

