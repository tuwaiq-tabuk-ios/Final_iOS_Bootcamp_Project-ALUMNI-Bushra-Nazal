//
//  ProfileVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 21/05/1443 AH.
//

import UIKit
import Firebase
import SDWebImage

class ProfileVC: UIViewController {
  
  let db = Firestore.firestore()
  
  var imageCheck = false
  var userID = ""
  
  
  //MARK: - IBOutlets
  @IBOutlet weak var scrollBottom: NSLayoutConstraint!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var mobileLabel: UILabel!
  @IBOutlet weak var mobileTextField: UITextField!
  @IBOutlet weak var githubTextField: UITextField!
  @IBOutlet weak var githubLabel: UILabel!
  @IBOutlet weak var preferedLanguage: UITextField!
  @IBOutlet weak var preferedLanguageLabel: UILabel!
  @IBOutlet weak var experianceYearsTextField: UITextField!
  @IBOutlet weak var experianceYearsLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var descriptionContainerView: UIView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if userID == "" {
      guard let id = Auth.auth().currentUser?.uid else {return}
      userID = id
      editButton.isHidden = false
    } else {
      editButton.isHidden = true
    }
    
    translateScreen()
    settingUpKeyboardNotifications()
    getUserDate()
    
    setUpInputs(status: false)
    
    firstNameTextField.isEnabled = false
    lastNameTextField.isEnabled = false
    emailTextField.isEnabled = false
    
    mobileTextField.delegate = self
    githubTextField.delegate = self
    preferedLanguage.delegate = self
    experianceYearsTextField.delegate = self
    descriptionTextView.delegate = self
    
    descriptionContainerView.layer.borderColor = UIColor.lightGray.cgColor
    descriptionContainerView.layer.borderWidth = 1
    descriptionContainerView.layer.cornerRadius = 8
    
    profileImage.layer.borderColor = UIColor.lightGray.cgColor
    profileImage.layer.borderWidth = 1
    profileImage.layer.cornerRadius = 60
    
    editButton.layer.cornerRadius = 15
    editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
  }
  
  
  func setUpInputs(status : Bool) {
    mobileTextField.isEnabled = status
    githubTextField.isEnabled = status
    preferedLanguage.isEnabled = status
    experianceYearsTextField.isEnabled = status
    descriptionTextView.isEditable = status
  }
  
  
  func getUserDate() {
    Firestore.firestore().collection("Users").document(userID).getDocument { snapshot, error in
      if error == nil {
        if let value = snapshot?.data() {
          self.firstNameTextField.text = value["firstName"] as? String
          self.lastNameTextField.text = value["lastName"] as? String
          self.emailTextField.text = value["email"] as? String
          self.mobileTextField.text = value["mobile"] as? String
          self.githubTextField.text = value["github"] as? String
          self.preferedLanguage.text = value["prefferedLanguage"] as? String
          self.experianceYearsTextField.text = value["experianceYears"] as? String
          self.descriptionTextView.text = value["description"] as? String
          if let imageUrl = value["profileImage"] as? String {
            // convert imageUrl to image
            self.profileImage.sd_setImage(with: URL(string: imageUrl)) { image, error, cache, url in
              self.profileImage.image = image
              self.imageCheck = true
            }
          }
        }
      }
    }
  }
  
  
  var toggleButton = true
  @IBAction func editButtonAction(_ sender: UIButton) {
    if toggleButton {
      editButton.setTitle("Save".localize(), for: .normal)
      profileImage.isUserInteractionEnabled = true
      
      profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAction)))
      
      setUpInputs(status: true)
      
    } else {
      
      editButton.isEnabled = false
      
      // validate inputs
      view.endEditing(true)
      
      if let mobile = mobileTextField.text, mobile.isEmpty == false  {
        mobileTextField.text = mobile
      } else {
        mobileTextField.text = "none".localize()
      }
      
      if let github = githubTextField.text, github.isEmpty == false  {
        githubTextField.text = github
      } else {
        githubTextField.text = "none".localize()
      }
      
      if let language = preferedLanguage.text, language.isEmpty == false  {
        preferedLanguage.text = language
      } else {
        preferedLanguage.text = "none".localize()
      }
      
      if let experiance = experianceYearsTextField.text, experiance.isEmpty == false  {
        experianceYearsTextField.text = experiance
      } else {
        experianceYearsTextField.text = "none".localize()
      }
      
      if let description = descriptionTextView.text, description.isEmpty == false  {
        descriptionTextView.text = description
      } else {
        descriptionTextView.text = "none".localize()
      }
      
      guard let userID = Auth.auth().currentUser?.uid else {return}
      
      createLoadingView()
      
      if imageCheck {
        guard let imageData = profileImage.image?.pngData() else {return}
        
        let storageRef = Storage.storage().reference().child("Profiles").child(userID)
        storageRef.putData(imageData, metadata: nil) { metadata, error in
          if error == nil {
            storageRef.downloadURL { [self] url, error in
              if error == nil {
                let imageURL = url?.absoluteString
                db.collection("Users").document(userID).updateData([
                  "firstName" : firstNameTextField.text!,
                  "lastName" : lastNameTextField.text!,
                  "email" : emailTextField.text!,
                  "id" : userID,
                  "mobile" : mobileTextField.text!,
                  "profileImage" : imageURL!,
                  "github" : githubTextField.text!,
                  "description" : descriptionTextView.text!,
                  "prefferedLanguage" : preferedLanguage.text!,
                  "experianceYears" : experianceYearsTextField.text!
                ]) { err in
                  if err == nil {
                    self.editButton.setTitle("Edit".localize(), for: .normal)
                    self.editButton.isEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadPosts"), object: nil, userInfo: nil)
                    finishLoadingView()
                    self.tabBarController?.selectedIndex = 0
                  }
                }
              }
            }
          }
        }
        
        
      } else {
        
        let profileData = ["firstName" : firstNameTextField.text!,
                           "lastName" : lastNameTextField.text!,
                           "email" : emailTextField.text!,
                           "id" : userID,
                           "mobile" : mobileTextField.text!,
                           "profileImage" : nil,
                           "github" : githubTextField.text!,
                           "description" : descriptionTextView.text!,
                           "prefferedLanguage" : preferedLanguage.text!,
                           "experianceYears" : experianceYearsTextField.text!]
        
        db.collection("Users").document(userID).updateData(profileData) { [self] err in
          if err == nil {
            self.editButton.setTitle("Edit".localize(), for: .normal)
            self.editButton.isEnabled = true
            finishLoadingView()
            self.tabBarController?.selectedIndex = 0
          }
        }
      }
      
      setUpInputs(status: false)
    }
    toggleButton.toggle()
  }
  
  
  var loadingView = UIView()
  var loadingSpinner = UIActivityIndicatorView()
  func createLoadingView() {
    tabBarController?.tabBar.isHidden = true
    loadingView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    
    loadingSpinner = UIActivityIndicatorView(frame: loadingView.bounds)
    loadingSpinner.startAnimating()
    loadingSpinner.style = .large
    loadingSpinner.tintColor = .darkGray
    loadingView.addSubview(loadingSpinner)
    view.addSubview(loadingView)
  }
  
  
  func finishLoadingView() {
    tabBarController?.tabBar.isHidden = false
    loadingView.removeFromSuperview()
  }
  
  
  //MARK: - Localizable
  func translateScreen() {
    firstNameLabel.text = "FirstName".localize()
    lastNameLabel.text = "LastName".localize()
    emailLabel.text = "Email".localize()
    mobileLabel.text = "Mobile".localize()
    githubLabel.text = "Github".localize()
    preferedLanguageLabel.text = "Programming language".localize()
    experianceYearsLabel.text = "Experiance Years".localize()
    descriptionLabel.text = "Description".localize()
    
  }
}


//MARK: - Image
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func imageAction() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    
    let actionSheet = UIAlertController(title: "Photo source", message: "", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { UIAlertAction in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
      } else {
        // show message
        print("Camera Not Available")
      }
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { UIAlertAction in
      imagePickerController.sourceType = .photoLibrary
      self.present(imagePickerController, animated: true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { UIAlertAction in}))
    
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    
    profileImage.image = selectedImage
    imageCheck = true
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

//MARK: - Keyboard
extension ProfileVC{
  func settingUpKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    let tabbarHeight = tabBarController?.tabBar.frame.height
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      self.scrollBottom.constant = keyboardSize.height - tabbarHeight!
      UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    self.scrollBottom.constant = 0
    UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}





