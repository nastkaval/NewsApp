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
  var isFiltering: Bool { get }
  func items(filteredBy: String?) -> [News]
  func loadData(isNextPage: Bool)
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
  func didTapDetails(at index: Int)
  func didStartFilter(keyWord: String)
  func didScrollToEnd()
  func didRefresh()
}

protocol NewsTableViewCellDelegate: AnyObject {
  func showDetailsView(from cell: UITableViewCell)
}

// MARK: - Controller
protocol NewsViewModel {
  var imageUrl: URL? { get }
  var url: URL? { get }
  var publishedAt: Date? { get }
  var title: String { get }
  var author: String { get }
  var descriptionText: String { get }
  var isSaved: Bool { get }
}

protocol NewsViewable: AnyObject {
  func updateUI(with data: [NewsViewModel])
  func showAlert(title: String, message: String)
  func showActionSheet()
  func showAnimation()
}

protocol NewsOutput: AnyObject {
  func openDetails(for news: News)
  func openOfflineNews()
}
