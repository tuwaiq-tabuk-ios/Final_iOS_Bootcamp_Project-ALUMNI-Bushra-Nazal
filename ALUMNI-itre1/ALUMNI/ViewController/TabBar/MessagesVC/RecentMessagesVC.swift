//
//  RecentMessagesVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit
import Firebase

class RecentMessagesVC: UITableViewController {
  
  let cellId = "Cell"
  var recentChats = [ChatUser]()
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getRecentChats { users in
      self.recentChats.removeAll()
      for userID in users {
        Firestore.firestore().collection(FSCollectionReference.users.rawValue).document(userID).getDocument { snapshot, error in
          if error == nil {
            if let value = snapshot?.data() {
              if let firstName = value["firstName"] as? String, let lastName = value["lastName"] as? String {
                let name = "\(firstName) \(lastName)"
                let profileImage = value["profileImage"] as? String
                self.recentChats.append(ChatUser(name: name, id: userID, profileImage: profileImage))
                self.tableView.reloadData()
                
                
              }
            }
          }
        }
      }
    }
    
    tableView.register(UINib(nibName: "RecentMessageCell", bundle: nil), forCellReuseIdentifier: cellId)
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recentChats.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecentMessageCell
    cell.usernameLabel.text = recentChats[indexPath.row].name
    
    if let url = recentChats[indexPath.row].profileImage {
      cell.profileImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: "person.circle.fill"))
    }
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let chatUser = ChatUser(name: recentChats[indexPath.row].name, id: recentChats[indexPath.row].id)
    performSegue(withIdentifier: k.Storyboard.segueGoToChat, sender: chatUser)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == k.Storyboard.segueGoToChat {
      let nextVC = segue.destination as! ChatVC
      nextVC.user = sender as? ChatUser
    }
  }
  
  
  func getRecentChats(completion : @escaping ([String])->()) {
    Firestore.firestore().collection(FSCollectionReference.messages.rawValue).addSnapshotListener { snapshot, error in
      
      if let value = snapshot?.documents {
        var tempUsers = [String]()
        
        for i in value {
          let data = i.data()
          let sender = data["sender"] as? String
          let reciever = data["reciever"] as? String
          guard let currentUserId = Auth.auth().currentUser?.uid else {return}
          
          
          if (sender == currentUserId) || (reciever == currentUserId) {
            if sender != currentUserId {
              if !tempUsers.contains(sender!) {
                tempUsers.append(sender!)
              }
              
            }
            if reciever != currentUserId {
              if !tempUsers.contains(reciever!) {
                tempUsers.append(reciever!)
              }
            }
          }
        }
        completion(tempUsers)
      }
    }
  }
  
  
}
