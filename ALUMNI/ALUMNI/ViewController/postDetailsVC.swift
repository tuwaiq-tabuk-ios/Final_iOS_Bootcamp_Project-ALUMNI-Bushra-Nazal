//
//  DetailsVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 19/05/1443 AH.
//

import Foundation
import UIKit


class postDetailsVC: UIViewController {
 
    
    var post: Post!
  
    // MARK: OUTLETS
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
   
     
  
  
    // MARK: LIFE CYCLE METHODS
      override func viewDidLoad() {
          super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        postTextLabel.text = post.text
        postImageView.image = post.image
  
}
 
}




extension postDetailsVC: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return 1
//  comments.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
//  let currentComment = comments[indexPath.row]
//  cell.userNameLabel.text = currentComment.owner.firstName + " " + currentComment.owner.lastName
//  cell.commentMessageLabel.text = currentComment.message
 return cell
}
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 107
  }
}
