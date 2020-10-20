//
//  UIView.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

extension UIView {
  func pinEdgesToSuperView() {
    guard let superView = superview else { return }
    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
    leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
  }
}
