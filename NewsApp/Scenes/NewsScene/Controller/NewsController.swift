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
  func presentView(view: DetailesView)
}

final class NewsController {
  private var modelNews: NewsModel
  private weak var output: NewsControllerOutput?

  private var isFiltering: Bool = false

  init(model: NewsModel, output: NewsControllerOutput) {
    self.modelNews = model
    self.output = output
  }
}

extension NewsController: NewsViewInput {
  var count: Int {
    return modelNews.count()
  }

  func provideObject(at index: IndexPath) -> ViewModel {
    let object = modelNews.object(index.row)
    return object
  }
}

extension NewsController: NewsViewOutput {
  func showDetailes(at index: IndexPath) {
    let news = provideObject(at: index) //bad??
    let detailesView = DetailesViewCoordinator().instantiate(news: news)
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
    modelNews.getData(isNextPage: false)
  }
}

extension NewsController: NewsModelOutput {
  func dataLoadSuccess() {
    isFiltering = false
    output?.displayUpdate()
  }

  func dataLoadWithError(_ errorMessage: String) {
    output?.displayAlert(title: R.string.localizable.errorTitle(), message: errorMessage)
  }
}