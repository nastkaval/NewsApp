//
//  DatabaseManager.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/22/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {

  private var realm: Realm
  static let shared = DatabaseManager()

  private init() {
    do {
      realm = try Realm()
    } catch {
      fatalError()
    }
  }

  func loadData() -> [NewsEntity] {
    return realm.objects(NewsEntity.self).toArray()
  }

  func loadFilterData(predicate: String) -> [NewsEntity] {
    return realm.objects(NewsEntity.self).filter("title contains '\(predicate)'").toArray()
  }

  func removeAllData() {
    try! realm.write {
      realm.deleteAll()
    }
  }

  func saveData(newsEntities: [NewsEntity]) {
    try! realm.write {
      realm.add(newsEntities)
    }
  }
}
