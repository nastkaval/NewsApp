//
//  DatabaseService.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseService {
  // swiftlint:disable force_try
  static let realm = try! Realm()

  static func loadData() -> [NewsEntity] {
    return realm.objects(NewsEntity.self).toArray(ofType: NewsEntity.self)
  }

  static func filterNews(predicate: String) -> [NewsEntity] {
    return realm.objects(NewsEntity.self).filter("title contains '\(predicate)'").toArray(ofType: NewsEntity.self)
  }
}
