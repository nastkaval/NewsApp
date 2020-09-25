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

  var description: String {
    switch self {
    case .initDatabaseError:
      return R.string.localizable.initDatabaseErrorMessage()
    case .saveError:
      return R.string.localizable.saveErrorMessage()
    case .removeDatabaseError:
      return R.string.localizable.cleanDatabaseErrorMessage()
    }
  }
}

protocol DatabaseProtocol: class {
  func saveData(newsEntities: [NewsEntity], callBack: @escaping (Result<Any?, DatabaseDataError>) -> Void)
  func loadData(callBack: @escaping (Result<[NewsEntity], DatabaseDataError>) -> Void)
  func filterData(keyWord: String, callBack: @escaping (Result<[NewsEntity], DatabaseDataError>) -> Void)
  func removeData(callBack: @escaping (Result<Any?, DatabaseDataError>) -> Void)
}

final class DatabaseManager: DatabaseProtocol {
  private static var sharedDatabaseManager: DatabaseManager = {
    let databaseManager = DatabaseManager()
    return databaseManager
  }()

  static func shared() -> DatabaseManager {
    return sharedDatabaseManager
  }

  private init() { }

  func loadData(callBack: @escaping (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    do {
      let realm = try Realm()
      let newsArray = realm.objects(NewsEntity.self).toArray()
      return callBack(.success(newsArray))
    } catch {
      return callBack(.failure(.initDatabaseError))
    }
  }

  func filterData(keyWord: String, callBack: @escaping (Result<[NewsEntity], DatabaseDataError>) -> Void) {
    do {
      let realm = try Realm()
      let newsArray = realm.objects(NewsEntity.self).filter("title contains '\(keyWord)'").toArray()
      return callBack(.success(newsArray))
    } catch {
      return callBack(.failure(.initDatabaseError))
    }
  }

  func removeData(callBack: @escaping (Result<Any?, DatabaseDataError>) -> Void) {
    do {
      let realm = try Realm()
      try realm.write { //https://medium.com/@m4rr/realm-and-the-forced-try-expression-72eeb599b29d
        realm.deleteAll()
      }
      return callBack(.success(nil))
    } catch {
      return callBack(.failure(.removeDatabaseError))
    }
  }

  func saveData(newsEntities: [NewsEntity], callBack: @escaping (Result<Any?, DatabaseDataError>) -> Void) {
    do {
      let realm = try Realm()
      try realm.write { //https://medium.com/@m4rr/realm-and-the-forced-try-expression-72eeb599b29d
        realm.add(newsEntities)
      }
      return callBack(.success(nil))
    } catch {
      return callBack(.failure(.saveError))
    }
  }
}
