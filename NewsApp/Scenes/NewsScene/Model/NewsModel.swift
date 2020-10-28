//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsDataSource: AnyObject {
  var items: [News] { get }
  func loadDataFromApi(withNextPage: Bool)
  func filterData(by keyWord: String) -> [News]
}

protocol NewsDataSourceDelegate: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

final class NewsModel {
  private var session = SessionData()
  var items: [News] = []

  weak var delegate: NewsDataSourceDelegate?
  private let apiManager: ApiManagerProtocol

  init(loadService: ApiManagerProtocol) {
    self.apiManager = loadService
  }
}

extension NewsModel: NewsDataSource {
  func loadDataFromApi(withNextPage: Bool) {
    if withNextPage {
      session.page += 1
    } else {
      session.page = 1
    }
    apiManager.callApi(session: session) { [weak self] result in
      switch result {
      case .success(let newsArray):
        self?.items.append(contentsOf: newsArray)
        self?.delegate?.dataLoadSuccess()
      case .failure(let error):
        self?.delegate?.dataLoadWithError(error.localizableDescription)
      }
    }
  }

  func filterData(by keyWord: String) -> [News] {
    guard keyWord.count > 2 else {
      return items
    }
    let filteredArray = items.filter { $0.title.lowercased().contains("\(keyWord.lowercased())") }
    return filteredArray
  }
}
