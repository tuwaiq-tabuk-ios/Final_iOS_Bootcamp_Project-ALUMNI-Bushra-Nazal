//
//  PostDetailsVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit
import Firebase
import SDWebImage

class PostDetailsVC: UIViewController {

  @IBOutlet weak var postLabel: UILabel!
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var postImageViewHeight: NSLayoutConstraint!
  @IBOutlet weak var commentsTableView: UITableView!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var sendCommentButton: UIButton!
  @IBOutlet weak var inputViewBottomLayout: NSLayoutConstraint!
  
  var post : Post?
  var comments = [Comment]()
  
  let db = Firestore.firestore()
  
  var commentUserName = String()
  var commentUserAvatar = String()
  
  var myLikeID = String()
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      print("POST ID : ", post?.postID)
      
      guard let userID = Auth.auth().currentUser?.uid else {return}
      db.collection("Users").document(userID).getDocument { [self] snapshot, error in
          if error == nil {
              if let value = snapshot?.data() {
                  if let firstName = value["firstName"] as? String, let lastName = value["lastName"] as? String {
                      commentUserName = "\(firstName) \(lastName)"
                  }
                  if let avatar = value["profileImage"] as? String {
                      commentUserAvatar = avatar
                  }
                      
              }
          }
      }
      
      
      commentTextView.delegate = self
      sendCommentButton.isEnabled = false
      postImageView.layer.cornerRadius = 12
      commentTextView.layer.cornerRadius = 20
      
      commentsTableView.delegate = self
      commentsTableView.dataSource = self
      commentsTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "Cell")

      if let postUserName = post?.userName {
          self.navigationItem.title = postUserName
      }
      
      if let postText = post?.postText {
          postLabel.text = postText
      }
      
      if let postImage = post?.postImageUrl {
          if let url = URL(string: postImage) {
              postImageView.sd_setImage(with: url) { image, error, cache, url in
                  self.postImageView.image = image
                  self.postImageViewHeight.constant = 200
              }
          }
      } else {
          self.postImageViewHeight.constant = 0
      }
      
      getPostComments()
      settingUpKeyboardNotifications()
  }
  
  @IBAction func showUserProfile(_ sender: Any) {
      let vc = storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
      if let id = post?.userID {
          vc.userID = id
//            self.present(vc, animated: true, completion: nil)
          self.navigationController?.pushViewController(vc, animated: true)
      }
  }
  
  
  
  
  
  
  
  @IBAction func sendButtonAction(_ sender: UIButton) {
      guard let comment = commentTextView.text else {return}
      let commentID = UUID().uuidString
      let timestamp = Date().timeIntervalSince1970
      db.collection("Comments").document(commentID).setData([
          "commentID" : commentID,
          "commentText" : comment,
          "postID" : post?.postID,
          "commentUserName" : commentUserName,
          "commentAvatarUrl" : commentUserAvatar,
          "commentDate" : sendDate(),
          "timestamp" : timestamp
      ]) { error in
          if error == nil {
              self.view.endEditing(true)
              self.commentTextView.text = "comment here"
              self.commentTextView.textColor = .lightGray
              self.getPostComments()
          }
      }
  }
  
  func getPostComments() {
      comments.removeAll()
      guard let postID = post?.postID else {return}
      db.collection("Comments").order(by: "timestamp", descending: true).whereField("postID", isEqualTo: postID).addSnapshotListener { snapshot, error in
          print("\n###########\n")
          if error == nil {
              if let value = snapshot?.documents {
                  for i in value {
                      let data = i.data()
                      let commentID = data["commentID"] as? String
                      let commentText = data["commentText"] as? String
                      let postID = data["postID"] as? String
                      let commentUserName = data["commentUserName"] as? String
                      let commentAvatarUrl = data["commentAvatarUrl"] as? String
                      let commentDate = data["commentDate"] as? String
                      let timestamp = data["timestamp"] as? TimeInterval
                                              
                      let comment = Comment(commentID: commentID, commentText: commentText, postID: postID, commentUserName: commentUserName, commentAvatarUrl: commentAvatarUrl, commentDate: commentDate, timestamp: timestamp)
                      self.comments.append(comment)
                  }
                  
                  print("Comments :\n",self.comments)
                  self.commentsTableView.reloadData()
              }
          }
      }
      
  }
  
  
  @IBAction func directMessageAction(_ sender: UIButton) {
      let chatUser = ChatUser(name: post?.userName, id: post?.userID)
      performSegue(withIdentifier: "goToChat", sender: chatUser)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let vc = segue.destination as! ChatVC
      vc.user = sender as? ChatUser
  }
  
  
  
}

extension PostDetailsVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = commentsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentCell
      let comment = comments[indexPath.row]
      cell.commentUserNameLabel.text = comment.commentUserName
      cell.commentLabel.text = comment.commentText
      cell.commentDateLabel.text = comment.commentDate
      if let avatarUrl = comment.commentAvatarUrl {
          cell.commentUserAvatar.sd_setImage(with: URL(string: avatarUrl), placeholderImage: UIImage(systemName: "person.circle.fill"))
      }
      return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(comments[indexPath.row])
  }
  
  
}


extension PostDetailsVC {
  func textViewDidChange(_ textView: UITextView) {
      let trimText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimText.count > 0 {
          self.sendCommentButton.isEnabled = true
      } else {
          self.sendCommentButton.isEnabled = false
      }
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == "comment here" {
          textView.text = ""
          textView.textColor = .darkGray
      }
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text == "" {
          textView.text = "comment here"
          textView.textColor = .lightGray
      }
  }
}

// Keyboard
extension PostDetailsVC {
  
  func settingUpKeyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector: #selector(PostDetailsVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(PostDetailsVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
      let tabbarHeight = tabBarController?.tabBar.frame.height
      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
          self.inputViewBottomLayout.constant = keyboardSize.height - tabbarHeight!
          UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
              self.view.layoutIfNeeded()
          }, completion: nil)
      }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
  self.inputViewBottomLayout.constant = 0
      UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
          self.view.layoutIfNeeded()
      }, completion: nil)
  }
}

