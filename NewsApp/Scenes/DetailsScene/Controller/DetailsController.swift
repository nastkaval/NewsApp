//
//  DetailsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

final class DetailsController {
  private let model: DetailsDataSource
  private weak var view: DetailsViewable?
  private let output: DetailsViewCoordinator

  init(model: DetailsDataSource, view: DetailsViewable, output: DetailsViewCoordinator) {
    self.model = model
    self.view = view
    self.output = output
  }
}

// MARK: - DetailsControllable
extension DetailsController: DetailsControllable {
  func didLoadView() {
    model.saveData()
  }

  func didTapOpenUrl() {
    if let url = model.item.url {
      UIApplication.shared.open(url)
    }
  }

  func didTapClose() {
    output.hide()
  }
}

// MARK: - DetailsDataSourceDelegate
extension DetailsController: DetailsDataSourceDelegate {
  func dataLoadSuccess() {
    view?.updateUI(with: model.item)
  }

  func dataLoadWithError(_ errorMessage: String) {
    view?.showAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}
