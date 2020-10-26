//
//  DetailesController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol DetailesControllerOutput: AnyObject {
  func updateUI()
  func displayAlert(title: String, message: String)
  func dismissView()
}

final class DetailesController {
  private let model: DetailesModel
  private weak var output: DetailesControllerOutput?
  private let coordinator: DetailesViewCoordinator

  init(model: DetailesModel, output: DetailesControllerOutput, coordinator: DetailesViewCoordinator) {
    self.model = model
    self.output = output
    self.coordinator = coordinator
  }
}

// MARK: - DetailesViewOutput
extension DetailesController: DetailesViewOutput {
  func userInterfaceDidLoad() {
    model.checkIsExistObjectInDatabase()
  }

  func openNewsInExternalResource() {
    let newsUrl = object.newsUrl
    if let url = newsUrl {
      UIApplication.shared.open(url)
    }
  }

  func closeView() {
    coordinator.hide()
  }
}

extension DetailesController: DetailesViewInput {
  var object: ViewModel {
    return model.object()
  }
}

// MARK: - DetailesModelOutput
extension DetailesController: DetailesModelOutput {
  func dataLoadSuccess() {
    output?.updateUI()
  }

  func dataLoadWithError(_ errorMessage: String) {
    output?.displayAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}
