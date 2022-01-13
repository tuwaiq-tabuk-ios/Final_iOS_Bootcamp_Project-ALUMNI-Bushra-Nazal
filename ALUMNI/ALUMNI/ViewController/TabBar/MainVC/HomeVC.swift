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
  
  var isSearching = false
  var posts = [Post]()
  var filteredPosts = [Post]()
  var me = String()
  
  
  //MARK: - IBOutlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var postsTableView: UITableView!
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    me = Auth.auth().currentUser!.uid
    
    postsTableView.dataSource = self
    postsTableView.delegate = self
    postsTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "Cell")
    
    searchBar.delegate = self
    
    createNewPostButton()
    
    getPosts()
    
    translateScreen()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(getPosts), name: NSNotification.Name(rawValue: "reloadPosts"), object: nil)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
  }
  
  
  @objc func getPosts(){
    posts.removeAll()
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
                self.posts.append(Post(postID: i.postID ,postText: i.postText, timestamp: i.timestamp, postImageUrl: i.postImageUrl, userID: i.userID, postDate: i.postDate, userName: userName, profileImageUrl: profileImageUrl))
                
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
    newPostButton.backgroundColor = .systemBlue
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
    performSegue(withIdentifier: k.Storyboard.newPostVC ,sender: nil)
  }
  
  //MARK: - SignOut
  @IBAction func signoutAction(_ sender: UIBarButtonItem) {
    try? Auth.auth().signOut()
    let vc = self.storyboard?.instantiateViewController(withIdentifier:k.Storyboard.signInUpVC)
    vc?.modalPresentationStyle = .fullScreen
    vc?.modalTransitionStyle = .crossDissolve
    DispatchQueue.main.async {
      self.present(vc!, animated: true, completion: nil)
    }
    
  }
  
  
}

// MARK: - Table view data source

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearching {
      return filteredPosts.count
    } else {
      return posts.count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = postsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
    
    if isSearching {
      //      return filteredPosts.count
      let post = filteredPosts[indexPath.row]
      cell.postLabel.text = post.postText
      cell.userNameLabel.text = post.userName
      
      if let profileUrl = post.profileImageUrl {
        cell.userAvatar.sd_setImage(with: URL(string: profileUrl), placeholderImage: UIImage(systemName: "person.circle.fill"))
      } else {
        cell.userAvatar.image = UIImage(systemName: "person.circle.fill")
      }
      
      if post.postImageUrl == nil {
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
      
    }else{
      //      return posts.count
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
      
    }
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isSearching {
      performSegue(withIdentifier: k.Storyboard.segueGoToPostDetails, sender: filteredPosts[indexPath.row])
    } else {
      performSegue(withIdentifier: k.Storyboard.segueGoToPostDetails, sender: posts[indexPath.row])
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == k.Storyboard.segueGoToPostDetails {
      let destination = segue.destination as! PostDetailsVC
      destination.post = sender as? Post
    }
  }
  
  
  //MARK: - Delete
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if posts[indexPath.row].userID == me {
      if editingStyle == .delete{
        alertAction(id: posts[indexPath.row].postID!)
      }
    }
  }
  
  
  func alertAction(id: String){
    let alert = UIAlertController(title: "Delete".localize(), message: "Are you sure!".localize(), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok".localize(), style: .destructive, handler: { action in
      Firestore.firestore().collection("Posts").document(id).delete()
    }))
    alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .default, handler: { action in }))
    self.present(alert, animated: true, completion: nil)
  }
  
  
  func tableView(_tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool {
    return posts[indexPath.row].userID == me
    
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
            
            tempPosts.append(Post(postID: post.documentID, postText: postText, timestamp: timestamp, postImageUrl: postImageUrl, userID: userID, postDate: postDate, userName: userName, profileImageUrl: profileImageUrl))
            
          }
          completion(tempPosts)
        }
      }
    }
  }
}

//MARK: - SearchBar
extension HomeVC: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
  }
  
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    isSearching = false
  }
  
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
    searchBar.text = ""
    view.endEditing(true)
  }
  
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
  }
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredPosts.removeAll()
    if searchText == "" {
      isSearching = false
      self.postsTableView.reloadData()
    }
    else {
      isSearching = true
      filteredPosts = posts.filter({ post in
        return post.postText!.lowercased().contains(searchText.lowercased())
      })
      self.postsTableView.reloadData()
    }
  }
  
  //MARK: - Localizable
  func translateScreen() {
    searchBar.placeholder = "search".localize()
  }
}
