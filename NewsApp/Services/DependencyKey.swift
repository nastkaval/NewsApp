//
//  DependencyKey.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class DependencyKey: Hashable, Equatable {
  private let type: Any.Type
  private let name: String

  init(type: Any.Type, name: String) {
    self.type = type
    self.name = name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(type))
    hasher.combine(name)
  }

  static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name
  }
}
