//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsViewDelegate: AnyObject {
  func updateUI()
  func displayAlert(title: String, message: String)
  func displayActionSheet()
  func displayLoadAnimation()
}

final class NewsController {
  private var modelNews: NewsModel
  private weak var delegate: NewsViewDelegate?
  private let coordinator: NewsViewCoordinator
  private var isFiltering = false

  init(model: NewsModel, delegate: NewsViewDelegate, coordinator: NewsViewCoordinator) {
    self.modelNews = model
    self.delegate = delegate
    self.coordinator = coordinator
  }
}

// MARK: - NewsViewOutput
extension NewsController: NewsControllerDelegate {
  func showOfflineCollectionNews() {
    coordinator.openOfflineCollectionNews()
  }

  func menuClicked() {
    delegate?.displayActionSheet()
  }

  func showDetails(at index: IndexPath) {
    let newsModel = modelNews.object(index.row)
    coordinator.openDetailsNews(newsModel: newsModel)
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
    delegate?.displayLoadAnimation()
    modelNews.getData(isNextPage: false)
  }
}

// MARK: - NewsModelOutput
extension NewsController: NewsModelDelegate {
  func dataLoadSuccess() {
    isFiltering = false
    delegate?.updateUI()
  }

  func dataLoadWithError(_ errorMessage: String) {
    delegate?.displayAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}

// MARK: - NewsViewInput
extension NewsController: NewsViewDataSource {
  var count: Int {
    return modelNews.count()
  }

  func provideObject(at index: IndexPath) -> NewsViewModel {
    return modelNews.object(index.row)
  }
}
