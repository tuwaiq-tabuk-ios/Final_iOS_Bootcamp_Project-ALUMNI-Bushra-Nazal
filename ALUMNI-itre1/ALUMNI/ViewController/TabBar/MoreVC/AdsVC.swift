//
//  AdsVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit
import Firebase

class AdsVC: UITableViewController {
  
  var ads = [Ad]()
  let db = Firestore.firestore().collection(FSCollectionReference.ads.rawValue)
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getAllAds()
  }
  
  @IBAction func newAdAction(_ sender: UIBarButtonItem) {
    
    //1. Create the alert controller.
    let alert = UIAlertController(title: "Ads".localize(), message: "Enter a new Ad".localize(), preferredStyle: .alert)
    
    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
      textField.placeholder = "Ad Title".localize()
    }
    
    // 3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "OK".localize(), style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
      guard let text = textField?.text, text.isEmpty == false else {return}
      guard let userID = Auth.auth().currentUser?.uid else {return}
      let adID = UUID().uuidString
      self.db.document(adID).setData([
        "adID" : adID,
        "text" : text,
        "userID" : userID,
        "timestamp" : Date().timeIntervalSince1970
      ])
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel ))
    
    // 4. Present the alert.
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func getAllAds() {
    db.order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
      self.ads.removeAll()
      if let value = snapshot?.documents {
        for i in value {
          let data = i.data()
          let adID = data["adID"] as? String
          let text = data["text"] as? String
          let userID = data["userID"] as? String
          self.ads.append(Ad(adID: adID, text: text, userID: userID))
        }
        self.tableView.reloadData()
      }
    }
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ads.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.textLabel?.text = ads[indexPath.row].text
    
    return cell
  }
  
}
