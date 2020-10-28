//
//  NewsProtocols.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

// MARK: - Model
protocol NewsDataSource: AnyObject {
  var items: [News] { get }
  func loadDataFromApi(withNextPage: Bool)
  func filterData(by keyWord: String) -> [News]
}

protocol NewsDataSourceDelegate: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

// MARK: - View
protocol NewsControllable: AnyObject {
  func didLoadView()
  func didTapMenu()
  func didTapOffline()
  func didTapDetails(at index: IndexPath)
  func didStartFilter(keyWord: String)
  func didScrollToEnd()
  func didRefresh()
}

protocol NewsTableViewCellDelegate: AnyObject {
  func showDetailsView(from cell: UITableViewCell)
}

// MARK: - Controller
protocol NewsViewModel {
  var urlToImage: URL? { get }
  var urlNews: URL? { get }
  var publishedAtDate: Date? { get }
  var title: String { get }
  var author: String { get }
  var descriptionNews: String { get }
  var isSaved: Bool { get }
}

protocol NewsViewable: AnyObject {
  func updateUI(with data: [NewsViewModel])
  func showAlert(title: String, message: String)
  func showActionSheet()
  func showAnimation()
}

protocol NewsModuleOutput: AnyObject {
  func openDetailsNews(news: News)
  func openOfflineCollectionNews()
}
