//
//  MoreVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit

class MoreVC: UIViewController {
  
  @IBOutlet weak var coursesButton: UIButton!
  @IBOutlet weak var adsButton: UIButton!
  @IBOutlet weak var aboutUsButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    coursesButton.layer.cornerRadius = 20
    adsButton.layer.cornerRadius = 20
    aboutUsButton.layer.cornerRadius = 20
    
    translateScreen()
  }
  
  //MARK: - Localizable
  func translateScreen() {
    coursesButton.setTitle(NSLocalizedString("courses", comment: ""), for: .normal)
    adsButton.setTitle(NSLocalizedString("ads", comment: ""), for: .normal)
    aboutUsButton.setTitle(NSLocalizedString("aboutUs", comment: ""), for: .normal)
    
  }
  
}
