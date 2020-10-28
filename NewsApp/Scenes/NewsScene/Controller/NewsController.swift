//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class NewsController {
  // MARK: - Properties
  private var model: NewsDataSource
  private let output: NewsModuleOutput
  private weak var view: NewsViewable?

  private var isFiltering = false

  init(model: NewsDataSource, view: NewsViewable, output: NewsModuleOutput) {
    self.model = model
    self.view = view
    self.output = output
  }
}

// MARK: - NewsControllable
extension NewsController: NewsControllable {
  func didLoadView() {
    model.loadDataFromApi(withNextPage: false)
  }

  func didTapOffline() {
    output.openOfflineCollectionNews()
  }

  func didTapDetails(at index: IndexPath) {
    let news = model.items[index.row]
    output.openDetailsNews(news: news)
  }

  func didStartFilter(keyWord: String) {
    let filteredResult = model.filterData(by: keyWord)
    view?.updateUI(with: filteredResult)
  }

  func didScrollToEnd() {
    if !isFiltering {
    model.loadDataFromApi(withNextPage: true)
    }
  }

  func didRefresh() {
    model.loadDataFromApi(withNextPage: false)
  }

  func didTapMenu() {
    view?.showActionSheet()
  }
}

// MARK: - NewsDataSourceDelegate
extension NewsController: NewsDataSourceDelegate {
  func dataLoadSuccess() {
    view?.updateUI(with: model.items)
  }

  func dataLoadWithError(_ errorMessage: String) {
    view?.showAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}

// MARK: - NewsViewModel
extension News: NewsViewModel {
}
