//
//  UIViewController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

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
    alertController.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
}
