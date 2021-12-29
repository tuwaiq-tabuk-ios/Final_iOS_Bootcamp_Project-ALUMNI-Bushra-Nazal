//
//  ChatViewController.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 22/05/1443 AH.
//

import UIKit
import Firebase


class ChatVC: UIViewController {

  @IBOutlet weak var messageTableView: UITableView!
  @IBOutlet weak var messageTextField: UITextField!
  
  let db = Firestore.firestore()
  var messages: [Messages] = []
  
  override func viewDidLoad() {
        super.viewDidLoad()
     loadData()
    messageTableView.delegate = self
    messageTableView.dataSource = self
   
    }
    
  func loadData(){
    db.collection("Messges").order(by: "time").addSnapshotListener { (querySnapshot, error) in
      if let snapchotDoc = querySnapshot?.documents {
        self.messages = []
        for doc in snapchotDoc {
        let data = doc.data()
          if let messageSender = data["sender"] as? String,
             let messageText = data["text"] as? String {
            let newMessage = Messages(sender: messageSender, body: messageText)
            
            self.messages.append(newMessage)
            DispatchQueue.main.async {
              self.messageTableView.reloadData()
          }
        }
      }
    }
  }
  }
  
  @IBAction func sendButtonPressed(_ sender: Any) {
    if let messageText = messageTextField.text,
       let messageSender = Auth.auth().currentUser?.email {
      
      db.collection("Messges").addDocument(data: [
        "sender" : messageSender,
        "text": messageText,
        "time": Date().timeIntervalSince1970
      ]) {(error) in
        if let err = error {
          print(err)
        } else {
          DispatchQueue.main.async {
            self.messageTextField.text = ""
          }
          
        }
    }
      
    }
    
  }
}

extension ChatVC: UITableViewDataSource,UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = messageTableView.dequeueReusableCell(withIdentifier:"ChatVC") as! MessageCell
    cell.messageLabel.text = messages[indexPath.row].body
    cell.backgroundColor = .clear
    
    let message = messages[indexPath.row]
    if message.sender == Auth.auth().currentUser?.email{
      cell.getMessageDesign(sender: .me)
    } else{
      cell.getMessageDesign(sender: .other)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
}
