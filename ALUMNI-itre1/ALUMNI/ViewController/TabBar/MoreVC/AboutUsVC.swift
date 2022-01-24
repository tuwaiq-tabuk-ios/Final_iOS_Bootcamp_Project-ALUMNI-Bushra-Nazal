//
//  AboutUsVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/06/1443 AH.
//

import UIKit


class AboutUsVC: UIViewController{
  
  @IBOutlet weak var aboutUsTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    aboutUsTextView.text = "This program is specially designed for graduates of university students for students of the computer department in all its fields to set a specific goal after graduation and determine a programming direction commensurate with his field of study and spend time after graduation in teaching programming and acquiring skills and experience with other students and by contributing with some companies and employment partners Providing various courses in the field of programming And provide job advertisements in line with the qualifications of the students.".localize()
    
  }
  
}
