//
//  Utilities.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import Foundation
import UIKit

class Utilities {

static func styleTextField(_ textfield:UITextField) {
  // Create the bottom line
  let bottomLine = CALayer()
  bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height:2)
  
  bottomLine.backgroundColor = UIColor.init(red: 121/255, green:135/255, blue: 255/255, alpha: 1).cgColor
  
  textfield.borderStyle = .none
  
  textfield.layer.addSublayer(bottomLine)

}
  
  static func styleFilledButton(_ button:UIButton){
    button.backgroundColor = UIColor.init(red: 121/255, green: 135/255, blue: 255/255, alpha: 1)
    button.layer.cornerRadius = 25.0
    button.tintColor = UIColor.white
  }
  
  static func styleHollowButton(_ button: UIButton){
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.cornerRadius = 25.0
    button.tintColor = UIColor.black
  }
  
  static func isPasswordValid(_ password : String) -> Bool {
  let passWordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passWordTest.evaluate(with: password)
}
}
