//
//  ViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 15/05/1443 AH.
//

import UIKit

class WelcomeVC: UIViewController {
    
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      setupUI()
  
}
  
  
  func setupUI() {
    signUpButton.layer.cornerRadius = 25
    loginButton.layer.cornerRadius = 25
    titleLabel.text = ""
    var charIndex = 0.0
    let titleText = "ALUMNI"
    for letter in titleText {
        Timer.scheduledTimer(withTimeInterval: 0.4 * charIndex, repeats: false) { (timer) in
            self.titleLabel.text?.append(letter)
        }
        charIndex += 1
    }
   
  }
  }
