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
  
  //MARK: - IBOutlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    translateScreen()
    setupUI()
    
  }
  
  
  //MARK: - IBAction
  @IBAction func signupButtonAction(_ sender : UIButton) {
    signUp()
  }
  
  
  //MARK: - Methode
  
  private func signUp() {
    
    guard let firstName = firstNameTextField.text, firstName.isEmpty == false else {
      firstNameTextField.shakeView()
      return
    }
    
    guard let lastName = lastNameTextField.text, lastName.isEmpty == false else {
      lastNameTextField.shakeView()
      return
    }
    
    guard let email = emailTextField.text, email.isEmpty == false else {
      emailTextField.shakeView()
      return
    }
    
    guard let password = passwordTextField.text, password.isEmpty == false else {
      passwordTextField.shakeView()
      return
    }
    
    guard let confirmPassword = confirmPasswordTextField.text, confirmPassword.isEmpty == false else {
      confirmPasswordTextField.shakeView()
      return
    }
    
    if password != confirmPassword {
      errorLabel.isHidden = false
      errorLabel.text = "Password Not Match".localize()
      return
    }
    

      Auth
        .auth()
        .createUser(withEmail: emailTextField.text!,
                    password: passwordTextField.text!) { [self] result, error in
          if error == nil {
            errorLabel.isHidden = true
            guard let userID = result?.user.uid else {return}
            Firestore.firestore().collection("Users").document(userID).setData([
              "firstName" : firstNameTextField.text!,
              "lastName" : lastNameTextField.text!,
              "email" : emailTextField.text!,
              "id" : userID
            ]) { err in
              if err == nil {
                // Go To HomeViewController
                let vc = self.storyboard?.instantiateViewController(withIdentifier:k.Storyboard.homeViewController)
                vc?.modalTransitionStyle = .crossDissolve
                vc?.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                  self.present(vc!, animated: true, completion: nil)
                }
              }
            }
          } else {
            errorLabel.isHidden = false
            errorLabel.text = error?.localizedDescription
          }
        }
    }
  }


extension SignUpVC {
  func setupUI() {
    //    errorLabel.alpha = 0
    errorLabel.isHidden = true
    
    firstNameTextField.layer.cornerRadius = 20
    lastNameTextField.layer.cornerRadius = 20
    emailTextField.layer.cornerRadius = 20
    passwordTextField.layer.cornerRadius = 20
    signUpButton.layer.cornerRadius = 20
    confirmPasswordTextField.layer.cornerRadius = 20
    
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
    
    let paddingView5: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
    confirmPasswordTextField.leftView = paddingView5
    confirmPasswordTextField.leftViewMode = .always
  
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  //MARK: - Localizable
  func translateScreen() {
    titleLabel.text = "SignUp".localize()
    firstNameTextField.placeholder = "firstName".localize()
    lastNameTextField.placeholder = "lastName".localize()
    emailTextField.placeholder = "email".localize()
    passwordTextField.placeholder = "password".localize()
    errorLabel.text = "errorSignUp".localize()
    signUpButton.setTitle(NSLocalizedString("signUp", comment: ""), for: .normal)
  }
}

