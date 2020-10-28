//
//  DetailsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol DetailsViewDelegate: AnyObject {
  func updateUI()
  func displayAlert(title: String, message: String)
  func dismissView()
}

final class DetailsController {
  private let model: DetailsModel
  private weak var delegate: DetailsViewDelegate?
  private let coordinator: DetailsViewCoordinator

  init(model: DetailsModel, delegate: DetailsViewDelegate, coordinator: DetailsViewCoordinator) {
    self.model = model
    self.delegate = delegate
    self.coordinator = coordinator
  }
}

// MARK: - DetailsViewOutput
extension DetailsController: DetailsControllerDelegate {
  func userInterfaceDidLoad() {
    model.checkIsExistObjectInDatabase()
  }

  func openNewsInExternalResource() {
    let newsUrl = object.urlNews
    if let url = newsUrl {
      UIApplication.shared.open(url)
    }
  }

  func closeView() {
    coordinator.hide()
  }
}

extension DetailsController: DetailsViewInput {
  var object: NewsViewModel {
    return model.object()
  }
}

// MARK: - DetailsModelOutput
extension DetailsController: DetailsModelOutput {
  func dataLoadSuccess() {
    delegate?.updateUI()
  }

  func dataLoadWithError(_ errorMessage: String) {
    delegate?.displayAlert(title: R.string.localizable.errorMessagesErrorTitle(), message: errorMessage)
  }
}
