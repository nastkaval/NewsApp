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
  case removeDatabaseError
  case noObject

  var localizableDescription: String {
    switch self {
    case .initDatabaseError:
      return R.string.localizable.errorMessagesInitDatabaseError()
    case .saveError:
      return R.string.localizable.errorMessagesSaveError()
    case .removeDatabaseError:
      return R.string.localizable.errorMessagesCleanDatabaseError()
    case .noObject:
      return R.string.localizable.errorMessagesNoObject()
    }
  }
}

typealias ID = String
protocol DatabaseProtocol: AnyObject {
  func save(data: NewsEntity) -> Bool
  func loadData() -> [NewsEntity]
  func filterData(byTitle: String, callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void)
  func removeData(byId: ID) -> Bool
  func checkObject(byId: ID) -> Bool
}

final class DatabaseManager: DatabaseProtocol {
  private let realm: Realm

  init?() {
    do {
      self.realm = try Realm()
    } catch {
      return nil
    }
  }

  func loadData() -> [NewsEntity] {
    let newsArray = realm.objects(NewsEntity.self).sorted(byKeyPath: "publishedAtStr", ascending: false).toArray()
    return newsArray
  }

  func filterData(byTitle: String, callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    let newsArray = realm.objects(NewsEntity.self).filter("title contains '\(byTitle)'").toArray()
    return callBack(.success(newsArray))
  }

  func checkObject(byId: ID) -> Bool {
    guard realm.objects(NewsEntity.self).filter("urlNewsStr == %@", byId).first != nil else {
      return false
    }
    return true
  }

  func removeData(byId: ID) -> Bool {
    do {
      let objectShouldDelete = realm.objects(NewsEntity.self).filter("urlNewsStr == %@", byId)
      try realm.write {
        realm.delete(objectShouldDelete)
      }
      return true
    } catch {
      return false
    }
  }

  func save(data: NewsEntity) -> Bool {
    do {
      try realm.write {
        realm.add(data)
      }
      return true
    } catch {
      return false
    }
  }
}
