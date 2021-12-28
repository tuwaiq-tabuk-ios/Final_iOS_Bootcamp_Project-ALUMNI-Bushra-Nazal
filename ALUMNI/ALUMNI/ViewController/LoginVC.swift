//
//  LoginViewController.swift
//  Prototype-Firebase-Authentication
//
//  Created by bushra nazal alatwi on 10/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
      setupUI()
  }
  

  var emailCheck = false
  var passwordCheck = false
  
  @IBAction func loginButtonAction(_ sender: UIButton) {
      
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
      
      
      if emailCheck, passwordCheck {
          Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] result, error in
              if error == nil {
                  errorLabel.alpha = 0
                  
                  // Go To HomeViewController
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                  vc?.modalTransitionStyle = .crossDissolve
                  vc?.modalPresentationStyle = .fullScreen
                  DispatchQueue.main.async {
                      self.present(vc!, animated: true, completion: nil)
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

extension LoginVC {
  func setupUI() {
      errorLabel.alpha = 0
      
      emailTextField.layer.cornerRadius = 20
      passwordTextField.layer.cornerRadius = 20
      loginButton.layer.cornerRadius = 20
      
      let paddingView1: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
      emailTextField.leftView = paddingView1
      emailTextField.leftViewMode = .always
      
      let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
      passwordTextField.leftView = paddingView2
      passwordTextField.leftViewMode = .always
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      view.endEditing(true)
  }
}

