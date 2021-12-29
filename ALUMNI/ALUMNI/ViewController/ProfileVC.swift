//
//  ProfileVC.swift
//  Final_Project
//
//  Created by bushra nazal alatwi on 21/05/1443 AH.
//

import UIKit


class ProfileVC: UIViewController {

  @IBOutlet weak var scrollBottom: NSLayoutConstraint!
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var mobileTextField: UITextField!
  @IBOutlet weak var githubTextField: UITextField!
  @IBOutlet weak var preferedLanguage: UITextField!
  @IBOutlet weak var experianceYearsTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var descriptionContainerView: UIView!
  
  @IBOutlet weak var editButton: UIButton!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
