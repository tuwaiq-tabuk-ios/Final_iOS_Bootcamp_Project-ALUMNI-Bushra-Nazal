//
//  HomeViewController.swift
//  Prototype-Firebase-Authentication
//
//  Created by bushra nazal alatwi on 10/05/1443 AH.
//

import UIKit
import Firebase
import SDWebImage

class HomeVC: UIViewController {
  
  var posts = [Post]()
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var postsTableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    postsTableView.dataSource = self
    postsTableView.delegate = self
    postsTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "Cell")
    
    createNewPostButton()
    getPosts()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(getPosts), name: NSNotification.Name(rawValue: "reloadPosts"), object: nil)
  }
  
  @objc func getPosts(){
    getAllPosts { tempPosts in
      for i in tempPosts {
        Firestore.firestore().collection("Users").document(i.userID!).getDocument { snapshot, error in
          if error == nil {
            if let value = snapshot?.data() {
              let firstName = value["firstName"] as? String
              let lastName = value["lastName"] as? String
              let imageUrl = value["profileImage"] as? String
              if let first = firstName, let last = lastName {
                let userName = "\(first) \(last)"
                let profileImageUrl = imageUrl ?? ""
                self.posts.append(Post(postText: i.postText, timestamp: i.timestamp, postImageUrl: i.postImageUrl, userID: i.userID, postDate: i.postDate, userName: userName, profileImageUrl: profileImageUrl))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  self.posts = self.posts.sorted(by: {$0.timestamp! > $1.timestamp!})
                  self.postsTableView.reloadData()
                }
              }
            }
          }
        }
        
      }
      
    }
  }
  
  
  func createNewPostButton(){
    let newPostButton = UIButton()
    newPostButton.translatesAutoresizingMaskIntoConstraints = false
    newPostButton.setImage(UIImage(systemName: "plus"), for: .normal)
    newPostButton.tintColor = .white
    newPostButton.backgroundColor = .systemTeal
    newPostButton.layer.cornerRadius = 25
    newPostButton.layer.zPosition = 100
    newPostButton.addTarget(self, action: #selector(newPostClicked), for: .touchUpInside)
    view.addSubview(newPostButton)
    
    NSLayoutConstraint.activate([
      newPostButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
      newPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      newPostButton.widthAnchor.constraint(equalToConstant: 50),
      newPostButton.heightAnchor.constraint(equalTo: newPostButton.widthAnchor)
    ])
  }
  
  @objc func newPostClicked(){
    performSegue(withIdentifier: "newPost", sender: nil)
  }
  
  @IBAction func signoutAction(_ sender: UIBarButtonItem) {
    try? Auth.auth().signOut()
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInUpVC")
    vc?.modalPresentationStyle = .fullScreen
    vc?.modalTransitionStyle = .crossDissolve
    DispatchQueue.main.async {
      self.present(vc!, animated: true, completion: nil)
    }
    
  }
  
  
}


extension HomeVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = postsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
    let post = posts[indexPath.row]
    cell.postLabel.text = post.postText
    cell.userNameLabel.text = post.userName
    
    if let profileUrl = post.profileImageUrl {
      cell.userAvatar.sd_setImage(with: URL(string: profileUrl)) { image, error, cache, url in
        cell.userAvatar.image = image
      }
    } else {
      cell.userAvatar.image = UIImage(systemName: "person.circle.fill")
    }
    
    if post.postImageUrl == nil{
      cell.imageHeightConstraint.constant = 0
      cell.postImage.alpha = 0
    } else {
      if let postImageUrl = post.postImageUrl {
        cell.imageHeightConstraint.constant = 200
        cell.postImage.alpha = 1
        cell.postImage.sd_setImage(with: URL(string: postImageUrl)) { image, error, cache, url in
          cell.postImage.image = image
        }
      }
    }
    return cell
  }
}
extension HomeVC {
  func getAllPosts(completion: @escaping ([Post])->()){
    var tempPosts = [Post]()
    Firestore.firestore().collection("Posts").addSnapshotListener { snapshot, error in
      self.posts.removeAll()
      tempPosts.removeAll()
      if error == nil {
        if let value = snapshot?.documents {
          for post in value {
            let data = post.data()
            let postText = data["postText"] as? String
            let timestamp = data["timestamp"] as? TimeInterval
            let postImageUrl = data["postImageUrl"] as? String
            let userID = data["userID"] as? String
            let postDate = data["postDate"] as? String
            let userName = data["userName"] as? String
            let profileImageUrl = data["profileImageUrl"] as? String
            
            tempPosts.append(Post(postText: postText, timestamp: timestamp, postImageUrl: postImageUrl, userID: userID, postDate: postDate, userName: userName, profileImageUrl: profileImageUrl))
            
          }
          completion(tempPosts)
        }
      }
    }
  }
}
