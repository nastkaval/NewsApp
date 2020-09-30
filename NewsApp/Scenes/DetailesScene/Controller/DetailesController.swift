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
}

final class DetailesController {
  private let model: DetailesModel
  private let view: DetailesView
  private weak var output: DetailesControllerOutput?

  init(view: DetailesView, model: DetailesModel, output: DetailesControllerOutput) {
    self.view = view
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
    view.dismiss(animated: true, completion: nil)
  }
}

extension DetailesController: DetailesViewInput {
  var object: ViewModel {
    return model.object()
  }
}
