//
//  SignUpViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      setupUI()
 
  }
  
  var firstNameCheck = false
  var lastNameCheck = false
  var emailCheck = false
  var passwordCheck = false
  
  @IBAction func signupButtonAction(_ sender : UIButton) {

      if let firstName = firstNameTextField.text, firstName.isEmpty == false {
          firstNameCheck = true
      } else {
          firstNameCheck = false
          firstNameTextField.shakeView()
      }
      
      if let lastName = lastNameTextField.text, lastName.isEmpty == false {
          lastNameCheck = true
      } else {
          lastNameCheck = false
          lastNameTextField.shakeView()
      }
      
      if let email = emailTextField.text, email.isEmpty == false {
          emailCheck = true
      } else {
          emailCheck = false
          emailTextField.shakeView()
      }
      
      if let password = passwordTextField.text, password.isEmpty == false {
          passwordCheck = true
      } else {
          passwordCheck = false
          passwordTextField.shakeView()
      }
      
      if firstNameCheck, lastNameCheck, emailCheck, passwordCheck {
          Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] result, error in
              if error == nil {
                  errorLabel.alpha = 0
                  guard let userID = result?.user.uid else {return}
                  Firestore.firestore().collection("Users").document(userID).setData([
                      "firstName" : firstNameTextField.text!,
                      "lastName" : lastNameTextField.text!,
                      "email" : emailTextField.text!,
                      "id" : userID
                  ]) { err in
                      if err == nil {
                          // Go To HomeViewController
                          let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                          vc?.modalTransitionStyle = .crossDissolve
                          vc?.modalPresentationStyle = .fullScreen
                          DispatchQueue.main.async {
                              self.present(vc!, animated: true, completion: nil)
                          }
                      }
                  }
              } else {
                  // show error message
                  errorLabel.alpha = 1
                  errorLabel.text = error?.localizedDescription
              }
          }
      }
      
      
  }


}

extension SignUpVC {
  func setupUI() {
      errorLabel.alpha = 0
      
      firstNameTextField.layer.cornerRadius = 20
      lastNameTextField.layer.cornerRadius = 20
      emailTextField.layer.cornerRadius = 20
      passwordTextField.layer.cornerRadius = 20
      signUpButton.layer.cornerRadius = 20
      
      let paddingView1: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
      firstNameTextField.leftView = paddingView1
      firstNameTextField.leftViewMode = .always
      
      let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
      lastNameTextField.leftView = paddingView2
      lastNameTextField.leftViewMode = .always
      
      let paddingView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
      emailTextField.leftView = paddingView3
      emailTextField.leftViewMode = .always
      
      let paddingView4: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
      passwordTextField.leftView = paddingView4
      passwordTextField.leftViewMode = .always
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      view.endEditing(true)
  }
}

