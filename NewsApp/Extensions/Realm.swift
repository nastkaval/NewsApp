//
//  Realm.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
  func toArray() -> [Element] {
    return compactMap { $0 }
  }
}
