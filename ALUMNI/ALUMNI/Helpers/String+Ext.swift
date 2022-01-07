//
//  String+Ext.swift
//  ALUMNI
//
//  Created by bushra nazal alatwi on 02/06/1443 AH.
//

import UIKit

extension String {
  func localize() -> String {
    return NSLocalizedString(self,
                      tableName: "Localizable",
                      bundle: .main,
                      value: self,
                      comment: self)
  }
}
