//
//  UserLoginValidationVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 27/05/1443 AH.
//

import UIKit
import Firebase


class UserLoginValidationVC: UIViewController {
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if Auth.auth().currentUser?.uid == nil {
      //      go to singIn
      let vc = self.storyboard?.instantiateViewController(withIdentifier:k.Storyboard.signInUpVC)
      vc?.modalPresentationStyle = .fullScreen
      vc?.modalTransitionStyle = .crossDissolve
      DispatchQueue.main.async {
        self.present(vc!, animated: true, completion: nil)
      }
    } else {
      //       go to HomeVC
      let vc = self.storyboard?.instantiateViewController(withIdentifier: k.Storyboard.homeViewController)
      vc?.modalPresentationStyle = .fullScreen
      vc?.modalTransitionStyle = .crossDissolve
      DispatchQueue.main.async {
        self.present(vc!, animated: true, completion: nil)
      }
    }
  }
  
}
