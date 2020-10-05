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

  var description: String {
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

protocol DatabaseProtocol: class {
  func saveData(newsEntity: NewsEntity) -> Bool
  func loadData(callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void)
  func filterDataByTitle(title: String, callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void)
  func removeData() -> Bool
}

final class DatabaseManager: DatabaseProtocol {
  static let shared = DatabaseManager()
  func loadData(callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    do {
      let realm = try Realm()
      let newsArray = realm.objects(NewsEntity.self).toArray()
      return callBack(.success(newsArray))
    } catch {
      return callBack(.failure(.initDatabaseError))
    }
  }

  func filterDataByTitle(title: String, callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    do {
      let realm = try Realm()
      let newsArray = realm.objects(NewsEntity.self).filter("title contains '\(title)'").toArray()
      return callBack(.success(newsArray))
    } catch {
      return callBack(.failure(.initDatabaseError))
    }
  }

  func removeData() -> Bool {
    do {
      let realm = try Realm()
      try realm.write { //https://medium.com/@m4rr/realm-and-the-forced-try-expression-72eeb599b29d
        realm.deleteAll()
      }
      return true
    } catch {
      return false
    }
  }

  func saveData(newsEntity: NewsEntity) -> Bool {
    do {
      let realm = try Realm()
      try realm.write { //https://medium.com/@m4rr/realm-and-the-forced-try-expression-72eeb599b29d
        realm.add(newsEntity)
      }
      return true
    } catch {
      return false
    }
  }
}
