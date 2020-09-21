//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsControllerOutput {
  func displayAlert()
  func displayUpdate()
}

class NewsController {
  var output: NewsControllerOutput!

  lazy var provider: NewsProvider = { 
    let provider = NewsProvider()
    provider.delegate = self
    return provider
  }()
}

extension NewsController: NewsViewOutput {
  func pullToRefresh() {
    provider.removeData()
  }

  func userCleanFilterNews() {
    provider.getData()
  }

  func userFilteringNews(keyWord: String) {
    provider.filterNews(predicate: keyWord)
  }

  func actionScrollToBottom() {
    provider.callApi(isNextPage: true)
  }

  func userInterfaceDidLoad() {
    provider.callApi(isNextPage: false)
  }
}

extension NewsController: NewsViewInput {
  func newsForIndex(_ index: Int) -> NewsEntity {
    return provider.listNews[index]
  }

  var newsArray: [NewsEntity] {
    return provider.listNews
  }
}

extension NewsController: NewsProviderDelegate {
  func apiDidUpdateWithError() {
    output.displayAlert()
  }

  func apiDidUpdateSuccess() {
    output.displayUpdate()
  }

  func databaseDidUpdate() {
    output.displayUpdate()
  }

  func databaseDidFiltered() {
    output.displayUpdate()
  }
}

