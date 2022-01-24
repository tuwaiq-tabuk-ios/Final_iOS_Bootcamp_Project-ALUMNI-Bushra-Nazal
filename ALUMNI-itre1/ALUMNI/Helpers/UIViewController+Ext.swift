//
//  UITextView+Ext.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 27/05/1443 AH.
//

import UIKit

extension UIViewController : UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let trimmed = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.text = trimmed
    }
}

extension UIViewController : UITextViewDelegate {
    public func textViewDidEndEditing(_ textView: UITextView) {
        let trimmed = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        textView.text = trimmed
    }
}

extension UIViewController {
    func sendDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        let stringDate = formatter.string(from: Date())
        return stringDate
    }
    
    func sendTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let stringDate = formatter.string(from: Date())
        return stringDate
    }
}
