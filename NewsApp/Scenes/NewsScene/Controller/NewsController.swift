//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsViewModel {
  var imageUrl: URL? { get }
  var newsUrl: URL? { get }
  var publishedAt: Date? { get }
  var title: String { get }
  var author: String { get }
  var descriptionNews: String { get }
  var isNewsSaved: Bool { get }
}

protocol NewsViewable: AnyObject {
  func updateUI(with data: [NewsViewModel])
  func showAlert(title: String, message: String)
  func showActionSheet()
  func showAnimation()
}

protocol NewsModuleOutput: AnyObject {
  func openDetailsNews(news: News)
  func openOfflineCollectionNews()
}

final class NewsController {
  // MARK: - Properties
  private var model: NewsDataSource
  private let newsModuleOutput: NewsModuleOutput
  private weak var view: NewsViewable?

  private var isFiltering = false

  init(model: NewsDataSource, delegate: NewsViewable, newsModuleOutput: NewsModuleOutput) {
    self.model = model
    self.view = delegate
    self.newsModuleOutput = newsModuleOutput
  }
}

// MARK: - NewsControllable
extension NewsController: NewsControllable {
  func viewDidLoad() {
    model.loadDataFromApi(withNextPage: false)
  }

  func didTapMenu() {
    view?.showActionSheet()
  }

  func didFilteringStart(keyWord: String) {
    let filteredResult = model.filteringData(by: keyWord)
    view?.updateUI(with: filteredResult)
  }

  func didScrollTableView() {
    model.loadDataFromApi(withNextPage: true)
  }

  func didSwipeRefresh() {
    model.loadDataFromApi(withNextPage: false)
  }

  func didOfflineNewsButtonClick() {
    newsModuleOutput.openOfflineCollectionNews()
  }

  func didDetailesNewsButtonClick(at index: IndexPath) {
    let news = model.dataSource[index.row]
    newsModuleOutput.openDetailsNews(news: news)
  }
}

// MARK: - NewsDataSourceDelegate
extension NewsController: NewsDataSourceDelegate {
  func dataLoadSuccess() {
    view?.updateUI(with: model.dataSource)
  }

  func dataLoadWithError(_ errorMessage: String) {
    view?.showAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
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
