//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

enum TimeDateFormatters {
  static let hoursMinutesDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
  }()
}

final class NewsController {
  // MARK: - Properties
  private var model: NewsDataSource
  private let output: NewsOutput
  private weak var view: NewsViewable?

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
    output.openOfflineNews()
  }

  func didTapDetails(at index: Int) {
    let news = model.items(filteredBy: nil)[index]
    output.openDetails(for: news)
  }

  func didStartFilter(keyWord: String) {
    let filteredResult = model.items(filteredBy: keyWord)
    view?.updateUI(with: filteredResult)
  }

  func didScrollToEnd() {
    guard model.isFiltering else {
      model.loadData(isNextPage: true)
      return
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
  var publishedAtTime: String {
    return TimeDateFormatters.hoursMinutesDateFormatter.string(from: publishedAt ?? Date())
  }

  var publishedAtDay: String {
    return DayDateFormattersConverter.dayTimeDateFormatter.string(from: publishedAt ?? Date())
  }
}
