//
//  LoginViewController.swift
//  Prototype-Firebase-Authentication
//
//  Created by bushra nazal alatwi on 10/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  
  //MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    translateScreen()
    setupUI()
  }
  
  
  
  
  @IBAction func loginButtonAction(_ sender: UIButton) {
    login()
  }
  
  
  //MARK: - Methode
  
  private func login() {
    
    guard let email = emailTextField.text, email.isEmpty == false else {
      emailTextField.shakeView()
      return
    }
    
    guard let password = passwordTextField.text, password.isEmpty == false else {
      passwordTextField.shakeView()
      return
    }

      Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] result, error in
        if error == nil {
          //          errorLabel.alpha = 0
          errorLabel.isHidden = true
          
          // Go To HomeViewController
          let vc = self.storyboard?.instantiateViewController(withIdentifier:k.Storyboard.homeViewController)
          vc?.modalTransitionStyle = .crossDissolve
          vc?.modalPresentationStyle = .fullScreen
          DispatchQueue.main.async {
            self.present(vc!, animated: true, completion: nil)
          }
        } else {
          // show error message
          //          errorLabel.alpha = 1
          errorLabel.isHidden = false
          errorLabel.text = error?.localizedDescription
        }
      }
    }
  }


extension LoginVC {
  func setupUI() {
    //    errorLabel.alpha = 0
    errorLabel.isHidden = true
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
  
  //MARK: - Localizable
  func translateScreen() {
    emailTextField.placeholder = "email".localize()
    passwordTextField.placeholder = "password".localize()
    errorLabel.text = "error".localize()
    titleLabel.text = "Login".localize()
    loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
  }
}



