//
//  NewPostVCViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import UIKit

class NewPostVC: UIViewController {

  @IBOutlet weak var postContainerView : UIView!
  @IBOutlet weak var postTextView : UITextView!
  @IBOutlet weak var postImageView : UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      postContainerView.layer.cornerRadius = 8
      postContainerView.layer.borderWidth = 1
      postContainerView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
  
  @IBAction func sendPostAction(_ sender: UIBarButtonItem) {
      
  }
  
}
