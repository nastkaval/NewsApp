//
//  DetailsProtocols.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 11/2/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

// MARK: - Model
protocol DetailsDataSource: AnyObject {
  var item: News { get }
  func checkData()
}

protocol DetailsDataSourceDelegate: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

// MARK: - View
protocol DetailsControllable: AnyObject {
  func didLoadView()
  func didTapOpenUrl()
  func didTapClose()
}

// MARK: - Controller
protocol DetailsViewable: AnyObject {
  func updateUI(with data: NewsViewModel)
  func showAlert(title: String, message: String)
}

// MARK: - Coordinator
protocol DetailsViewCoordinatorDelegate: AnyObject {
  func closeDetailsView()
}
