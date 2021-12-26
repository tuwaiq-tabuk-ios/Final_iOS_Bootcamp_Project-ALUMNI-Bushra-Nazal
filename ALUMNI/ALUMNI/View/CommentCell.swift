//
//  CommentCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 19/05/1443 AH.
//

import UIKit

class CommentCell: UITableViewCell {
  

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var commentMessageLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
