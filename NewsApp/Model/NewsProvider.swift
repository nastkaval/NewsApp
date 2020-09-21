//
//  NewsProvider.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation
import RealmSwift

protocol WebServiceDelegate: class {
  func callApi(isNextPage: Bool)
}

protocol DatabaseServiceDelegate: class {
  func saveData(newsArray: [NewsEntity])
  func removeData()
  func getData()
  func filterNews(predicate: String)
}

protocol NewsProviderDelegate: class {
  func apiDidUpdateSuccess()
  func apiDidUpdateWithError()
  func databaseDidUpdate()
  func databaseDidFiltered()
}

class NewsProvider {
  var session: SessionData = SessionData()
  var isErrorLimit: Bool = false
  // swiftlint:disable force_try
  let realm = try! Realm()
  var listNews: [NewsEntity] = []
  public weak var delegate: NewsProviderDelegate?
}

extension NewsProvider: WebServiceDelegate {
  func callApi(isNextPage: Bool) {
    if isNextPage == true, isErrorLimit == false {
      session.currentPage += 1
    } else if isNextPage == true, isErrorLimit == true {
      return
    }
    ApiManager.shared.getNews(
      from: session.from,
      currentPage: session.currentPage,
      success: { result in
        self.listNews = result
        self.delegate?.apiDidUpdateSuccess()
      }, failed: { error in
        if error.code == 426 {
          self.isErrorLimit = true
          self.delegate?.apiDidUpdateWithError()
        }
      })
  }
}

extension NewsProvider: DatabaseServiceDelegate {
  func removeData() {
    try! realm.write {
      realm.deleteAll()
    }
  }

  func getData() {
    self.listNews = realm.objects(NewsEntity.self).toArray()
  }

  func saveData(newsArray: [NewsEntity]) {
    try! realm.write {
      realm.add(newsArray)
    }
  }

  func filterNews(predicate: String) {
    self.listNews = realm.objects(NewsEntity.self).filter("title contains '\(predicate)'").toArray()
  }
}
