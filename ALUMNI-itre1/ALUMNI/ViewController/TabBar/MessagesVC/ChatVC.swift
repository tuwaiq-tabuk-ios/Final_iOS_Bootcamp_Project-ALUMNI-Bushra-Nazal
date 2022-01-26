//
//  ChatVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatVC: UIViewController {
  
  var user : ChatUser?
  var userID = String()
  let db = Firestore.firestore()
  var messages = [Message]()
  
    //MARK: - IBOutlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageViewBottom: NSLayoutConstraint!
    
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    IQKeyboardManager.shared.enableAutoToolbar = false
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
      
      settingUpKeyboardNotifications()
    
    
    guard let id = Auth.auth().currentUser?.uid else {return}
    userID = id
    
    self.navigationItem.title = user?.name
    
    chatTableView.delegate = self
    chatTableView.dataSource = self
    chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
    
    messageTextView.layer.cornerRadius = 20
    messageTextView.delegate = self
    messageTextView.text = "Message here".localize()
    
    getAllMessages()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  
  func getAllMessages() {
    db.collection(FSCollectionReference.messages.rawValue).order(by: "timestamp", descending: false).addSnapshotListener { snapshot, error in
      self.messages.removeAll()
      if let value = snapshot?.documents {
        for i in value {
          let data = i.data()
          let sender = data["sender"] as? String
          let reciever = data["reciever"] as? String
          let messageText = data["messageText"] as? String
          let messageId = data["messageId"] as? String
          let time = data["time"] as? String
          
          if (sender == self.userID && reciever == self.user?.id) || (sender == self.user?.id && reciever == self.userID) {
            self.messages.append(Message(messageText: messageText, sender: sender, reciever: reciever, messageId: messageId, time: time))
          }
        }
        self.chatTableView.reloadData()
      }
    }
  }
  
  
  @IBAction func sendMessageAction(_ sender: UIButton) {
    guard let messageText = messageTextView.text else {return}
    let messageId = UUID().uuidString
    db.collection(FSCollectionReference.messages.rawValue).document(messageId).setData([
      "sender" : userID,
      "reciever" : user?.id ?? "nil",
      "messageText" : messageText,
      "messageId" : messageId,
      "timestamp" : Date().timeIntervalSince1970,
      "time" : sendTime()
      
    ]) { error in
      self.messageTextView.text = ""
      // show message in tableView
    }
    
  }
  
}
// MARK: - Table view data source
extension ChatVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = chatTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
    let message = messages[indexPath.row]
    cell.messageLabel.text = message.messageText
    cell.messageTime.text = message.time
    
    if message.sender == userID {
      cell.messageTime.textAlignment = .right
      cell.messageView.backgroundColor = .systemTeal
    } else {
      cell.messageTime.textAlignment = .left
      cell.messageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    return cell
  }
  
}


extension ChatVC {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "Message here" {
      textView.text = ""
    
    }
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.text = "Message here"
     
    }
  }
}


// Keyboard
extension ChatVC {
    
    func settingUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        messageViewBottom.constant = keyboardSize - view.safeAreaInsets.bottom

        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        let duration : TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        messageViewBottom.constant = 0

        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
}


