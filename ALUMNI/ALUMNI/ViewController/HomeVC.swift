//
//  HomeViewController.swift
//  Prototype-Firebase-Authentication
//
//  Created by bushra nazal alatwi on 10/05/1443 AH.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

  var postArray: [Post] = []
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var postsTableView: UITableView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      postsTableView.dataSource = self
      postsTableView.delegate = self
      postsTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "Cell")
      
      createNewPostButton()
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
     return postArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = postsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
    cell.likeLabel.text = "\(indexPath.row)"

    
    return cell
  }
}

