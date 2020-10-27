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

  init(type: Any.Type) {
    self.type = type
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(type))
  }

  static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
    return lhs.type == rhs.type
  }
}
