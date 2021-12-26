//
//  PostCellTableViewCell.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {
  
  
  @IBOutlet weak var userStackView: UIStackView!{
  didSet{
      userStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userStackViewTapped)))
  }
  }
  
  @IBOutlet weak var likesNumberLabel: UILabel!
  
  @IBOutlet weak var postTextLabel: UILabel!
  
  @IBOutlet weak var userNameLabel: UILabel!
  
  @IBOutlet weak var postImageView: UIImageView!
  
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var backView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @objc func userStackViewTapped(){
    NotificationCenter.default.post(name:NSNotification.Name("userStackViewTapped"),object: nil,userInfo:["cell": self])
  }
}

