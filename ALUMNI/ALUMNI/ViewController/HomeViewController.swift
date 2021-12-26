//
//  HomeViewController.swift
//  Prototype-Firebase-Authentication
//
//  Created by bushra nazal alatwi on 10/05/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {

  var postArray: [Post] = []
  
  @IBOutlet weak var postTableView: UITableView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      postTableView.dataSource = self
      postTableView.delegate = self
      // subscribing to the notification
      NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name(rawValue: "userStackViewTapped"), object: nil)
      
      // New post Notification
      NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdd) , name: NSNotification.Name(rawValue: "NewPostAdded"), object: nil)
    
    

    }
  
  @objc func newTodoAdd(notification: Notification){
    if let myPost = notification.userInfo?["addedPost"] as? Post {
      postArray.append(myPost)
      postTableView.reloadData()

    }
    
      }
  
  // MARK: ACTIONS
 @objc func userProfileTapped(notification: Notification){
  if let cell = notification.userInfo?["cell"] as? UITableViewCell{
    if let indexPath =  postTableView.indexPath(for: cell){
    let post = postArray[indexPath.row]
      let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
      
      navigationController?.pushViewController(vc, animated: true)
   }
  }

}
 }



extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return postArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    cell.postTextLabel.text = postArray[indexPath.row].text
    
    if postArray[indexPath.row].image != nil {
    cell.postImageView.image = postArray[indexPath.row].image
    }else{
      cell.postImageView.image = UIImage(named: "Image-5")
    }

    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedPost = postArray[indexPath.row]
    let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsVC") as!postDetailsVC
    vc.post = selectedPost
    navigationController?.pushViewController(vc, animated: true)
  }
}

