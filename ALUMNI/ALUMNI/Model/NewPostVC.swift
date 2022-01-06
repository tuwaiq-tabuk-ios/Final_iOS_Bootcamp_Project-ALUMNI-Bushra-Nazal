//
//  NewPostVCViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import UIKit
import Firebase


class NewPostVC: UIViewController {
  
  @IBOutlet weak var postContainerView : UIView!
  @IBOutlet weak var postTextView : UITextView!
  @IBOutlet weak var postImageView : UIImageView!
  @IBOutlet weak var sendPostButton: UIBarButtonItem!
  
  var postCheck = false
  var imageCheck = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.sendPostButton.isEnabled = false
    
    postContainerView.layer.cornerRadius = 8
    postContainerView.layer.borderWidth = 1
    postContainerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    postImageView.layer.cornerRadius = 12
    postTextView.becomeFirstResponder()
    postTextView.delegate = self
    
    toolBar()
    
    translateScreen()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  func toolBar(){
    let toolBar = UIToolbar()
    let selectImage = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(imageAction))
    toolBar.items = [selectImage]
    toolBar.sizeToFit()
    postTextView.inputAccessoryView = toolBar
  }
  
  @IBAction func sendPostAction(_ sender: UIBarButtonItem) {
    
    if imageCheck { // save postText and postImage
      
      //       save postImage to storage
      let storageRef = Storage.storage().reference().child(UUID().uuidString)
      guard let itemImageData = postImageView.image?.pngData() else {return}
      
      storageRef.putData(itemImageData, metadata: nil) {meta, error in
        if error == nil {
          storageRef.downloadURL { [self] url, error in
            if error == nil {
              if let imageUrl = url?.absoluteString {
                // save to firestore
                savePostData(postImageUrl: imageUrl)
              }
            }
            
          }
        }
      }
      
    } else {
      // save postText only
      savePostData(postImageUrl: nil)
    }
  }
  func savePostData(postImageUrl: String?){
    guard let userID = Auth.auth().currentUser?.uid else {return}
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-M-YYYY"
    let postData = formatter.string(from: Date())
    
    let timestamp = Date().timeIntervalSince1970
    let postID = UUID().uuidString
    Firestore.firestore().collection("Posts").document(postID).setData([
      "postText": postTextView.text!,
      "postImageUrl" : postImageUrl,
      "userID" : userID,
      "postDate": postData,
      "timestamp": timestamp,
      "postID" : postID
    ]){err in
      if err == nil {
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
}

// MARK: - Image
extension NewPostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  @objc func imageAction(){
    view.endEditing(true)
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    
    let actionSheet = UIAlertController(title: "Photo source", message: "", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { UIAlertAction in
      if UIImagePickerController.isSourceTypeAvailable(.camera){
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
      }else {
        // show message
        print("Camera Not Available")
      }
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { UIAlertAction in
      imagePickerController.sourceType = .photoLibrary
      self.present(imagePickerController, animated: true, completion: nil)
    }))
    
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    
    postImageView.image = selectedImage
    imageCheck = true
    postTextView.becomeFirstResponder()
    picker.dismiss(animated: true, completion: nil)
    
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    postTextView.becomeFirstResponder()
    picker.dismiss(animated: true, completion: nil)
  }
  
}

extension NewPostVC {
  func textViewDidChange(_ textView: UITextView){
    let trimText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimText.count > 0 {
      self.sendPostButton.isEnabled = true
    } else {
      self.sendPostButton.isEnabled = false
    }
  }
  
  func textViewDidBeginEditing(_ textView: UITextView){
    if textView.text == "post here" {
      textView.text = ""
      textView.textColor = .darkGray
    }
  }
  
  override func textViewDidEndEditing(_ textView: UITextView){
    if textView.text == "" {
      textView.text = "post here"
      textView.textColor = .lightGray
    }
  }
  
  //MARK: - Localizable
  func translateScreen() {
    postTextView.text = "post here".localize()
  }
  
}
