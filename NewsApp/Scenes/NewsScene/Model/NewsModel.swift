//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsModelDelegate: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

final class NewsModel {
  private var session = SessionData()
  private var listNews: [News] = []
  private var savedListNews: [News] = []
  weak var delegate: NewsModelDelegate?

  private let apiManager: ApiManagerProtocol

  init(loadService: ApiManagerProtocol) {
    self.apiManager = loadService
  }
}

extension NewsModel {
  func getData(isNextPage: Bool) {
    if isNextPage {
      session.page += 1
    } else {
      session.page = 1
    }
    apiManager.callApi(session: session) { [weak self] result in
      switch result {
      case .success(let newsArray):
        self?.listNews.append(contentsOf: newsArray)
        self?.savedListNews.append(contentsOf: newsArray)
        self?.delegate?.dataLoadSuccess()
      case .failure(let error):
        self?.delegate?.dataLoadWithError(error.localizableDescription)
      }
    }
  }

  func getFilterNews(keyWord: String) {
    if !keyWord.isEmpty, keyWord.count > 2 {
      listNews = listNews.filter { $0.title.lowercased().contains("\(keyWord.lowercased())") }
      delegate?.dataLoadSuccess()
    }
    if keyWord.isEmpty {
      listNews = savedListNews
      delegate?.dataLoadSuccess()
    }
  }

  func object(_ index: Int) -> News {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.endIndex
  }
}

// MARK: - NewsViewModel
extension News: NewsViewModel {
  var imageUrl: URL? {
    return urlToImage
  }

  var newsUrl: URL? {
    return urlNews
  }

  var publishedAt: Date? {
    return publishedAtDate
  }
}
