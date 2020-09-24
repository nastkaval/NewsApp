//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsControllerOutput {
  func displayAlert(title: String, message: String)
  func displayUpdate()
}

class NewsController {
  // swiftlint:disable implicitly_unwrapped_optional
  var output: NewsControllerOutput!
  private var isFiltering: Bool = false

  lazy var model: NewsModel = {
    let model = NewsModel()
    model.newsModelDelegate = self
    return model
  }()

  func configure(viewController: NewsView) {
    self.output = viewController
    viewController.output = self
    viewController.input = self
  }
}

extension NewsController: NewsViewInput {
  func provideObject(at index: IndexPath) -> ViewModel {
    guard let object = model.object(index.row) as? ViewModel else {
      fatalError("No cell source for indexPath")
    }
    return object
  }
  func count() -> Int {
    return model.count()
  }
}

extension NewsController: NewsViewOutput {
  func loadDataCurrentPage() {
    model.getData(isNextPage: false)
  }

  func userFilteringNews(keyWord: String) {
    if !keyWord.isEmpty, keyWord.count > 2 {
      isFiltering = true
      model.getFilterNews(keyWord: keyWord)
    } else if keyWord.isEmpty {
      isFiltering = false
      model.loadNews()
    }
  }

  func loadDataNextPage() {
    if !isFiltering {
      model.getData(isNextPage: true)
    }
  }

  func userInterfaceDidLoad() {
    model.getData(isNextPage: false)
  }
}

extension NewsEntity: ViewModel {
  var publishedAt: Date {
    return ServerDateFormatterConverter.serverDateFormatter.date(from: publishedAtStr)! //Q
  }

  var imageUrl: URL {
    let escapedString = urlToImageStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! //Q
    let url = URL(string: escapedString)! //Q
    return url
  }
}

extension NewsController: NewsModelDelegate {
  func dataDidUpdateSuccess() {
    output.displayUpdate()
  }

  func dataDidUpdateWithError(_ errorMessage: String) {
    output.displayAlert(title: R.string.localizable.errorTitle(), message: errorMessage)
  }
}
