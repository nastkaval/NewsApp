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
    model.callApi(isNextPage: false)
  }

  func userFilteringNews(keyWord: String) {
    if !keyWord.isEmpty, keyWord.count > 2 {
      isFiltering = true
      model.filterData(keyWord: keyWord)
    } else if keyWord.isEmpty {
      isFiltering = false
      model.loadData()
    }
  }

  func loadDataNextPage() {
    if !isFiltering {
      model.callApi(isNextPage: true)
    }
  }

  func userInterfaceDidLoad() {
    model.callApi(isNextPage: false)
  }
}

extension NewsEntity: ViewModel {
  var publishedAt: Date {
    return ServerDateFormatterConverter.serverDateFormatter.date(from: publishedAtStr)!
  }

  var imageUrl: URL {
    let escapedString = urlToImageStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    let url = URL(string: escapedString)!
    return url
  }
}

extension NewsController: NewsModelDelegate {
  func dataDidUpdateSuccess() {
    output.displayUpdate()
  }

  func dataDidUpdateWithError(_ errorMessage: String) {
    output.displayAlert(title: "Error", message: errorMessage)
  }
}
