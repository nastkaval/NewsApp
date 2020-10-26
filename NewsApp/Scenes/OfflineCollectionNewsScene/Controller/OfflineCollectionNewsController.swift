//
//  OfflineCollectionNewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol OfflineCollectionNewsControllerOutput: AnyObject {
  func updateUI(withNotFoundNewsView: Bool)
  func updateUIWithRemoveCellAt(index: IndexPath, withNotFoundNewsView: Bool)
  func displayAlert(message: String)
}

final class OfflineCollectionNewsController {
  private var indexPath: IndexPath?
  private var model: OfflineCollectionNewsModel
  private weak var output: OfflineCollectionNewsControllerOutput?
  private let coordinator: OfflineCollectionNewsCoordinator

  init(model: OfflineCollectionNewsModel, output: OfflineCollectionNewsControllerOutput?, coordinator: OfflineCollectionNewsCoordinator) {
    self.model = model
    self.output = output
    self.coordinator = coordinator
  }
}

extension OfflineCollectionNewsController: OfflineCollectionNewsViewInput {
  func provideObject(at index: IndexPath) -> ViewModel {
    return model.object(index.row)
  }

  var count: Int {
    return model.count()
  }
}

// MARK: - OfflineCollectionNewsViewOutput
extension OfflineCollectionNewsController: OfflineCollectionNewsViewOutput {
  func closeView() {
    coordinator.hide()
  }

  func deleteRowAt(index: IndexPath) {
    indexPath = index
    model.removeDataFromDatabase(from: index.row)
  }

  func userInterfaceDidLoad() {
    model.loadDataFromDatabase()
  }
}

// MARK: - OfflineCollectionNewsModelOutput
extension OfflineCollectionNewsController: OfflineCollectionNewsModelOutput {
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
