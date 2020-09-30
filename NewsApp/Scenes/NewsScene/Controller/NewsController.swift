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
  private weak var output: NewsControllerOutput?
  private var modelNews: NewsModel
  private var modelDetailedNews: DetailesModel?
  private var view: NewsView

  private var isFiltering: Bool = false

  init(view: NewsView, model: NewsModel, output: NewsControllerOutput) {
    self.view = view
    self.modelNews = model
    self.output = output
  }
}

extension NewsController: NewsViewInput {
  func provideObject(at index: IndexPath) -> ViewModel {
    guard let object = modelNews.object(index.row) as? ViewModel else {
      fatalError("No cell source for indexPath")
    }
    return object
  }

  func count() -> Int {
    return modelNews.count()
  }
}

extension NewsController: NewsViewOutput {
  func showDetailes(at index: IndexPath) {
    let news = provideObject(at: index) //bad??
    let detailesView = DetailesViewCoordinator().instantiate(news: news)
    view.present(detailesView, animated: true, completion: nil)
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
