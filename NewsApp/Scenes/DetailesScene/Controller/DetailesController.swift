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

  init(model: DetailesModel, output: DetailesControllerOutput) {
    self.model = model
    self.output = output
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
    output?.dismissView()
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
