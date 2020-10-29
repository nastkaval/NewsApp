//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class NewsModel {
  private var session = SessionData()
  private var items: [News] = []
  private(set) var isFiltering: Bool = false

  weak var delegate: NewsDataSourceDelegate?
  private let apiManager: ApiManagerProtocol

  init(loadService: ApiManagerProtocol) {
    self.apiManager = loadService
  }
}

extension NewsModel: NewsDataSource {
  func items(filteredBy: String?) -> [News] {
    guard let keyWord = filteredBy, keyWord.count > 2 else {
      isFiltering = false
      return items
    }
    isFiltering = true
    return items.filter { $0.title.lowercased().contains("\(keyWord.lowercased())") }
  }

  func loadData(isNextPage: Bool) {
    if isNextPage {
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
}
