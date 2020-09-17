//
//  Extensions.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/16/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import RealmSwift

// MARK: - UILabel
extension UILabel {
  var isTruncated: Bool {
    guard let labelText = text else {
      return false
    }

    let labelTextSize = (labelText as NSString).boundingRect(
      with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: [.font: font as Any],
      context: nil).size

    return labelTextSize.height > bounds.size.height
  }
}

// MARK: - UIViewController
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
    }))
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - Realm
extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for i in 0 ..< count {
      if let result = self[i] as? T {
        array.append(result)
      }
    }
    return array
  }
}
