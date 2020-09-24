//
//  DatabaseManager.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/22/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

enum DatabaseDataError: LocalizedError {
  case initDatabaseError
  case saveError
  case cleanDatabaseError

  var description: String {
    switch self {
    case .initDatabaseError:
      return R.string.localizable.initDatabaseErrorMessage()
    case .saveError:
      return R.string.localizable.saveErrorMessage()
    case .cleanDatabaseError:
      return R.string.localizable.cleanDatabaseErrorMessage()
    }
  }
}

protocol DatabaseProvider {
  func saveData(newsEntities: [NewsEntity])
  func loadData() -> [NewsEntity]
  func filterData(keyWord: String) -> [NewsEntity]
  func removeData()
}

class DatabaseManager {

  private var realm: Realm
  static let shared = DatabaseManager()

  private init() {
    do {
      realm = try Realm()
    } catch {
      fatalError("Realm can't init")
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

extension DatabaseProvider {
  func saveData(newsEntities: [NewsEntity]) {
    DatabaseManager.shared.saveData(newsEntities: newsEntities)
  }
  func loadData() -> [NewsEntity] {
    return DatabaseManager.shared.loadData()
  }
  func removeData() {
    DatabaseManager.shared.removeAllData()
  }
  func filterData(keyWord: String) -> [NewsEntity] {
    return DatabaseManager.shared.loadFilterData(predicate: keyWord)
  }
}
