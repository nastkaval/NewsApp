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
  func presentView(view: DetailesView)
  func pushView(view: OfflineNewsView)
  func pushCollectionView(view: OfflineCollectionNewsView)
}

final class NewsController {
  private var modelNews: NewsModel
  private weak var output: NewsControllerOutput?
  private var isFiltering = false

  init(model: NewsModel, output: NewsControllerOutput) {
    self.modelNews = model
    self.output = output
  }
}

// MARK: - NewsViewOutput
extension NewsController: NewsViewOutput {
  func showOfflineCollectionNews() {
    let view = OfflineCollectionNewsCoordinator().instantiate()
    output?.pushCollectionView(view: view)
  }

  func showOfflineNews() {
    let view = OfflineNewsViewCoordinator().instantiate()
    output?.pushView(view: view)
  }

  func menuClicked() {
    output?.displayActionSheet()
  }

  func showDetailes(at index: IndexPath) {
    let newsModel = modelNews.object(index.row)
    let detailesView = DetailesViewCoordinator().instantiate(news: newsModel)
    output?.presentView(view: detailesView)
  }

  func loadDataCurrentPage() {
    modelNews.getData(isNextPage: false)
  }

  func filterNews(keyWord: String) {
    modelNews.getFilterNews(keyWord: keyWord)
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
  func dataLoadSuccess() {
    isFiltering = false
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
