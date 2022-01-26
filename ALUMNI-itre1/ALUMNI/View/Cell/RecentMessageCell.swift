//
//  RecentMessageCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit

class RecentMessageCell: UITableViewCell {
  
  //MARK: - IBOutlets
  @IBOutlet weak var usernameLabel : UILabel!
  @IBOutlet weak var profileImage : UIImageView!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      profileImage.layer.cornerRadius = 30
    }

  
}
