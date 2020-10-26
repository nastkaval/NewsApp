//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsModelOutput: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
  func dataFilterNoResult()
  func dataFilterEnd()
}

final class NewsModel {
  private var session = SessionData()
  private var listNews: [NewsViewModel] = []
  private var savedListNews: [NewsViewModel] = []
  weak var output: NewsModelOutput?

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
        self?.output?.dataLoadSuccess()
      case .failure(let error):
        self?.output?.dataLoadWithError(error.localizableDescription)
      }
    }
  }

  func getFilterNews(keyWord: String) {
    if !keyWord.isEmpty, keyWord.count > 2 {
      listNews = savedListNews
      listNews = listNews.filter { $0.title.lowercased().contains("\(keyWord.lowercased())") }
      guard !listNews.isEmpty else {
        output?.dataFilterNoResult()
        return
      }
      output?.dataLoadSuccess()
    }
    if keyWord.isEmpty {
      listNews = savedListNews
      output?.dataFilterEnd()
    }
  }

  func object(_ index: Int) -> NewsViewModel {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.endIndex
  }
}

// MARK: - ViewModel
extension NewsViewModel: ViewModel {
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
