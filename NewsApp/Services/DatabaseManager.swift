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

protocol DatabaseProtocol: AnyObject {
  func saveData(newsEntity: NewsEntity) -> Bool
  func loadData() -> [NewsEntity]
  func filterDataByTitle(title: String, callBack: (Result<[NewsEntity], DatabaseDataError>) -> Void)
  func removeDataBy(id: String) -> Bool
  func checkObjectIsExistBy(id: String) -> NewsEntity?
}

final class DatabaseManager: DatabaseProtocol {
  static let shared = DatabaseManager()

  func loadData() -> [NewsEntity] {
    do {
      let realm = try Realm()
      let newsArray = realm.objects(NewsEntity.self).sorted(byKeyPath: "publishedAtStr", ascending: false).toArray()
      return newsArray
    } catch {
      fatalError(R.string.localizable.errorMessagesInitDatabaseError())
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

  func checkObjectIsExistBy(id: String) -> NewsEntity? {
    do {
      let realm = try Realm()
      let object = realm.objects(NewsEntity.self).filter("urlNewsStr == %@", id).first
      return object
    } catch {
      fatalError(R.string.localizable.errorMessagesInitDatabaseError())
    }
  }

  func removeDataBy(id: String) -> Bool {
    do {
      let realm = try Realm()
      let objectShouldDelete = realm.objects(NewsEntity.self).filter("urlNewsStr == %@", id)
      try realm.write {
        realm.delete(objectShouldDelete)
      }
      return true
    } catch {
      return false
    }
  }

  func saveData(newsEntity: NewsEntity) -> Bool {
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(newsEntity)
      }
      return true
    } catch {
      return false
    }
  }
}
