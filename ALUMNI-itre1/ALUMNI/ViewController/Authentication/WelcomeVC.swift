//
//  ViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 15/05/1443 AH.
//

import UIKit

class WelcomeVC: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    translateScreen()
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
  
  
  //MARK: - Localizable
  func translateScreen() {
    signUpButton.setTitle(NSLocalizedString("signUp", comment: ""), for: .normal)
    loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
    
  }
}


