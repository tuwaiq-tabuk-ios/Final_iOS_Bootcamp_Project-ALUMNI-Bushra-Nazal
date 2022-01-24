//
//  PostCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {

  //MARK: - IBOutlets
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var postLabel: UILabel!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
      postImage.layer.cornerRadius = 12
      userAvatar.layer.borderColor = UIColor.lightGray.cgColor
      userAvatar.layer.borderWidth = 1
      userAvatar.layer.cornerRadius = 15
    }

    
    }
    
