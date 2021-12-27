//
//  ShadowView.swift
//  Final_Project
//
//  Created by bushra nazal alatwi on 21/05/1443 AH.
//

import UIKit

class ShadowView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupShadow()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupShadow()
  }
  
  func setupShadow(){
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 0, height: 10)
    self.layer.shadowRadius = 10
    self.layer.cornerRadius = 10
  }

}
