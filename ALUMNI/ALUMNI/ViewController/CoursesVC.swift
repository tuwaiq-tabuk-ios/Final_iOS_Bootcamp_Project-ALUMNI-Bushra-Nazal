//
//  CoursesVC.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 29/05/1443 AH.
//

import UIKit
import Firebase

class CoursesVC: UITableViewController {
  
  var courses = [Course]()
  let db = Firestore.firestore().collection("Courses")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getAllCourses()
  }
  
  
  @IBAction func newAdAction(_ sender: UIBarButtonItem) {
    
    //1. Create the alert controller.
    let alert = UIAlertController(title: "Course".localize(), message: "Enter a new course".localize(), preferredStyle: .alert)
    
    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
      textField.placeholder = "Course Title".localize()
    }
    
    // 3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "OK".localize(), style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
      guard let text = textField?.text, text.isEmpty == false else {return}
      guard let userID = Auth.auth().currentUser?.uid else {return}
      let courseID = UUID().uuidString
      self.db.document(courseID).setData([
        "courseID" : courseID,
        "text" : text,
        "userID" : userID,
        "timestamp" : Date().timeIntervalSince1970
      ])
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel ))
    
    // 4. Present the alert.
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func getAllCourses() {
    db.order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
      self.courses.removeAll()
      if let value = snapshot?.documents {
        for i in value {
          let data = i.data()
          let adID = data["courseID"] as? String
          let text = data["text"] as? String
          let userID = data["userID"] as? String
          self.courses.append(Course(courseID: adID, text: text, userID: userID))
        }
        self.tableView.reloadData()
      }
    }
  }
  
  
  
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return courses.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.textLabel?.text = courses[indexPath.row].text
    
    return cell
  }
  
  
}

