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
}

final class NewsModel {
  private var session = SessionData()
  private var listNews: [NewsViewModel] = []
  private var savedListNews: [NewsViewModel] = []
  weak var output: NewsModelOutput?

  private let apiManager: ApiManagerProtocol

  init(apiManager: ApiManagerProtocol) {
    self.apiManager = apiManager
  }

  convenience init(dependency: ModelDependencyProtocol) {
    self.init(apiManager: dependency.apiManager)
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
      listNews = listNews.filter { $0.title.lowercased().contains("\(keyWord.lowercased())") }
      self.output?.dataLoadSuccess()
    }
    if keyWord.isEmpty {
      listNews = savedListNews
      self.output?.dataLoadSuccess()
    }
  }

  func object(_ index: Int) -> NewsViewModel {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.endIndex
  }
}

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
