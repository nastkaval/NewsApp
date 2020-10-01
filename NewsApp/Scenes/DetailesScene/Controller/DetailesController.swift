//
//  DetailesController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol DetailesControllerOutput: class {
  func updateUI()
  func dismiss()
}

final class DetailesController {
  private let model: DetailesModel
  private weak var output: DetailesControllerOutput?
  
  init(model: DetailesModel, output: DetailesControllerOutput) {
    self.model = model
    self.output = output
  }
}

extension DetailesController: DetailesViewOutput {
  func userInterfaceDidLoad() {
    output?.updateUI()
  }

  func openNewsInResource() {
    let newsUrl = object.newsUrl
    if let url = newsUrl {
      UIApplication.shared.open(url)
    }
  }

  func closeView() {
    output?.dismiss()
  }
}

extension DetailesController: DetailesViewInput {
  var object: ViewModel {
    return model.object()
  }
}
