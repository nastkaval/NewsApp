//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsControllerOutput: class {
  func displayAlert(title: String, message: String)
  func displayUpdate()
}

final class NewsController {
  // swiftlint:disable implicitly_unwrapped_optional
  weak var output: NewsControllerOutput!
  private var isFiltering: Bool = false
  var model: NewsModel!
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

  func filterNews(keyWord: String) {
    model.getFilterNews(keyWord: keyWord)
      isFiltering = true
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

extension NewsController: NewsModelOutput {
  func dataLoadSuccess() {
    isFiltering = false
    output.displayUpdate()
  }

  func dataLoadWithError(_ errorMessage: String) {
    output.displayAlert(title: R.string.localizable.errorTitle(), message: errorMessage)
  }
}
