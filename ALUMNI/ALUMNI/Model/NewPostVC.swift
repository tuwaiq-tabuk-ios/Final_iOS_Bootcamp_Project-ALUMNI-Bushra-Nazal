//
//  NewPostVCViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 16/05/1443 AH.
//

import UIKit

class NewPostVC: UIViewController {

  @IBOutlet weak var detailsTextView: UITextView!
  @IBOutlet weak var mainButton: UIButton!
  @IBOutlet weak var postImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
  
  @IBAction func changeButtonClicked(_ sender: Any) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func addButtonClicked(_ sender: Any) {
    
   
    let post = Post(image: postImageView.image, text: detailsTextView.text)
 
  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewPostAdded"), object: nil, userInfo:["addedPost":post])
    
    let alert = UIAlertController(title: "Added", message:"Added successfully", preferredStyle:.alert)

    let closeAction = UIAlertAction(title:"OK", style: UIAlertAction.Style.default) { _ in
      self.tabBarController?.selectedIndex = 0
      
      self.detailsTextView.text = ""
      self.postImageView.image = nil
    }
    alert.addAction(closeAction)
    present(alert, animated: true, completion: {
    
    })
    
   
  }
    
}

extension NewPostVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
    dismiss(animated: true, completion: nil)
    postImageView.image = image
  }
}
