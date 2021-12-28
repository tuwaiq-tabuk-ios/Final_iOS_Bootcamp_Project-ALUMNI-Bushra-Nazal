//
//  HomeViewController.swift
//  Prototype-Firebase-Authentication
//
//  Created by bushra nazal alatwi on 10/05/1443 AH.
//

import UIKit

class HomeVC: UIViewController {

  var postArray: [Post] = []
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var postsTableView: UITableView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      postsTableView.dataSource = self
      postsTableView.delegate = self
      postsTableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "Cell")
      
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

