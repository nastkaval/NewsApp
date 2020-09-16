//
//  Extensions.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/16/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

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
}
