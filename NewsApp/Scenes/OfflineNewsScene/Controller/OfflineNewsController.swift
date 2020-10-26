//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/06/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol OfflineNewsControllerOutput: class {
  func updateUI()
  func hideNewsNotFoundView(state: Bool)
}

final class OfflineNewsController {
  private var model: OfflineNewsModel
  private weak var output: OfflineNewsControllerOutput?

  init(model: OfflineNewsModel, output: OfflineNewsControllerOutput?) {
    self.model = model
    self.output = output
  }
}

extension OfflineNewsController: OfflineNewsViewInput {
  func provideObject(at index: IndexPath) -> ViewModel {
    return model.object(index.row)
  }

  var count: Int {
    return model.count()
  }
}

extension OfflineNewsController: OfflineNewsViewOutput {
  func deleteRowAt(index: IndexPath, callback: ((Bool) -> Void)) {
    if model.deleteDataFromDatabase(from: index.row) {
      callback(true)
    } else {
      callback(false)
    }
  }

  func userInterfaceDidLoad() {
    model.loadDataFromDatabase()
  }
}

extension OfflineNewsController: OfflineNewsModelOutput {
  func dataLoadSuccess(state: Bool) {
    output?.hideNewsNotFoundView(state: state)
    output?.updateUI()
  }
}
