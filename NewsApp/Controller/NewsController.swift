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
    let controller = NewsController()
    controller.output = viewController
    viewController.output = controller
    viewController.input = controller
  }
}

extension NewsController: NewsViewInput {
  var newsListTableDataSource: TableViewDataSource {
    return model
  }
}

extension NewsController: NewsViewOutput {
  func pullToRefresh() {
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
  
  func loadData() {
    if !isFiltering {
    model.callApi(isNextPage: true)
    }
  }

  func userInterfaceDidLoad() {
    model.callApi(isNextPage: false)
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

