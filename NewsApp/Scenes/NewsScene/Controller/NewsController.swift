//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsControllerOutput: AnyObject {
  func updateUI()
  func displayAlert(title: String, message: String)
  func displayActionSheet()
  func displayLoadAnimation()
  func displayNoResultView()
  func updateUIFilteringEnd()
}

final class NewsController {
  private var modelNews: NewsModel
  private weak var output: NewsControllerOutput?
  private let coordinator: NewsViewCoordinator
  private var isFiltering = false

  init(model: NewsModel, output: NewsControllerOutput, coordinator: NewsViewCoordinator) {
    self.modelNews = model
    self.output = output
    self.coordinator = coordinator
  }
}

// MARK: - NewsViewOutput
extension NewsController: NewsViewOutput {
  func showOfflineCollectionNews() {
    coordinator.openOfflineCollectionNews()
  }

  func menuClicked() {
    output?.displayActionSheet()
  }

  func showDetailes(at index: IndexPath) {
    let newsModel = modelNews.object(index.row)
    coordinator.openDetailesNews(newsModel: newsModel)
  }

  func loadDataCurrentPage() {
    modelNews.getData(isNextPage: false)
  }

  func filterNews(keyWord: String) {
    modelNews.getFilterNews(keyWord: keyWord)
    print(keyWord)
    isFiltering = true
  }

  func loadDataNextPage() {
    if !isFiltering {
      modelNews.getData(isNextPage: true)
    }
  }

  func userInterfaceDidLoad() {
    output?.displayLoadAnimation()
    modelNews.getData(isNextPage: false)
  }
}

// MARK: - NewsModelOutput
extension NewsController: NewsModelOutput {
  func dataFilterEnd() {
    isFiltering = false
    output?.updateUIFilteringEnd()
  }

  func dataFilterNoResult() {
    output?.displayNoResultView()
  }

  func dataLoadSuccess() {
    output?.updateUI()
  }

  func dataLoadWithError(_ errorMessage: String) {
    output?.displayAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}

// MARK: - NewsViewInput
extension NewsController: NewsViewInput {
  var count: Int {
    return modelNews.count()
  }

  func provideObject(at index: IndexPath) -> ViewModel {
    return modelNews.object(index.row)
  }
}
