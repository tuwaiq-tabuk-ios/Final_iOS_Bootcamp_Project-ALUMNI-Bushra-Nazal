//
//  ChatVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
  
  var user : ChatUser?
  var userID = String()
  let db = Firestore.firestore()
  
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var sendMessageButton: UIButton!
  
 var messages = [Message]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      guard let id = Auth.auth().currentUser?.uid else {return}
      userID = id
              
      self.navigationItem.title = user?.name
      
      chatTableView.delegate = self
      chatTableView.dataSource = self
      chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
      
      messageTextView.layer.cornerRadius = 20
      messageTextView.delegate = self
      
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
      db.collection("Messages").order(by: "timestamp", descending: false).addSnapshotListener { snapshot, error in
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
      db.collection("Messages").document(messageId).setData([
          "sender" : userID,
          "reciever" : user?.id,
          "messageText" : messageText,
          "messageId" : messageId,
          "timestamp" : Date().timeIntervalSince1970,
//          "time" : sendTime()

      ]) { error in
          self.messageTextView.text = ""
          // show message in tableView
      }
      
  }
  
}

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
          cell.messageViewRight.priority = .defaultHigh
          cell.messageViewLeft.priority = .defaultLow
          cell.messageTime.textAlignment = .right
          cell.messageView.backgroundColor = .systemTeal
      } else {
          cell.messageViewRight.priority = .defaultLow
          cell.messageViewLeft.priority = .defaultHigh
          cell.messageTime.textAlignment = .left
          cell.messageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
      }
      
      return cell
  }
  
  
}


extension ChatVC {
//    func textViewDidChange(_ textView: UITextView) {
//        let trimText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        if trimText.count > 0 {
//            self.sendCommentButton.isEnabled = true
//        } else {
//            self.sendCommentButton.isEnabled = false
//        }
//    }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == "Message here" {
          textView.text = ""
          textView.textColor = .darkGray
      }
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text == "" {
          textView.text = "Message here"
          textView.textColor = .lightGray
      }
  }
}
