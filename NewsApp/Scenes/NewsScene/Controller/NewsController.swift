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
  private let output: NewsOutput
  private weak var view: NewsViewable?

  var isFiltering = false

  init(model: NewsDataSource, view: NewsViewable, output: NewsOutput) {
    self.model = model
    self.view = view
    self.output = output
  }
}

// MARK: - NewsControllable
extension NewsController: NewsControllable {
  func didLoadView() {
    model.loadData(isNextPage: false)
  }

  func didTapOffline() {
    output.openOfflineCollectionNews()
  }

  func didTapDetails(at index: IndexPath) {
    let news = model.items(filteredBy: nil)[index.row]
    output.openDetails(for: news)
  }

  func didStartFilter(keyWord: String) {
    let filteredResult = model.items(filteredBy: keyWord)
    view?.updateUI(with: filteredResult)
  }

  func didScrollToEnd() {
    if !isFiltering {
    model.loadData(isNextPage: true)
    }
  }

  func didRefresh() {
    model.loadData(isNextPage: false)
  }

  func didTapMenu() {
    view?.showActionSheet()
  }
}

// MARK: - NewsDataSourceDelegate
extension NewsController: NewsDataSourceDelegate {
  func dataLoadSuccess() {
    view?.updateUI(with: model.items(filteredBy: nil))
  }

  func dataLoadWithError(_ errorMessage: String) {
    view?.showAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}

// MARK: - NewsViewModel
extension News: NewsViewModel {
}
