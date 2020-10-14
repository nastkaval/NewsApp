//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/06/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol OfflineNewsControllerOutput: AnyObject {
  func updateUI(withNotFoundNewsView: Bool)
  func updateUIWithRemoveCellAt(index: IndexPath, withNotFoundNewsView: Bool)
  func displayAlert(message: String)
}

final class OfflineNewsController {
  private var indexPath: IndexPath?
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
  func deleteRowAt(index: IndexPath) {
    indexPath = index
    model.removeDataFromDatabase(from: index.row)
  }

  func userInterfaceDidLoad() {
    model.loadDataFromDatabase()
  }
}

extension OfflineNewsController: OfflineNewsModelOutput {
  func dataLoadSuccess() {
    output?.updateUI(withNotFoundNewsView: model.isModelEmpty)
  }

  func dataRemovedSuccess() {
    guard let index = indexPath else { return }
    output?.updateUIWithRemoveCellAt(index: index, withNotFoundNewsView: model.isModelEmpty)
  }

  func dataLoadFailed() {
    output?.displayAlert(message: R.string.localizable.errorMessagesNoObject())
  }

  func dataRemovedFailed() {
    output?.displayAlert(message: R.string.localizable.errorMessagesErrorRemoving())
  }
}
