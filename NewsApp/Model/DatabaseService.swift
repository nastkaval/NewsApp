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
    return realm.objects(NewsEntity.self).toArray()
  }

  static func saveData(newsJSON: [[String: Any]], success: @escaping () -> Void) {
    for dict in newsJSON {
      let newsEntity = NewsEntity()
      newsEntity.author = dict["author"] as? String ?? ""
      newsEntity.title = dict["title"] as? String ?? ""
      newsEntity.descriptionNews = dict["description"] as? String ?? ""
      newsEntity.url = dict["url"] as? String ?? ""
      newsEntity.urlToImage = dict["urlToImage"] as? String ?? ""
      let date = dict["publishedAt"] as? String ?? ""
      newsEntity.publishedAt = ServerDateFormatterConverter.serverDateFormatter.date(from: date)
      newsEntity.content = dict["content"] as? String ?? ""
      // swiftlint:disable force_try
      let realm = try! Realm()
      // swiftlint:disable force_try
      try! realm.write {
        realm.add(newsEntity)
      }
    }
    success()
  }

  static func filterNews(predicate: String) -> [NewsEntity] {
    return realm.objects(NewsEntity.self).filter("title contains '\(predicate)'").toArray()
  }
}
