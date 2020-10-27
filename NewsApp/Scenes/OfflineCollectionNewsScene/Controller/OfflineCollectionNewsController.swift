//
//  OfflineCollectionNewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol OfflineCollectionNewsViewDelegate: AnyObject {
  func updateUI(withNotFoundNewsView: Bool)
  func updateUIWithRemoveCellAt(index: IndexPath, withNotFoundNewsView: Bool)
  func displayAlert(message: String)
}

final class OfflineCollectionNewsController {
  private var indexPath: IndexPath?
  private var model: OfflineCollectionNewsModel
  private weak var delegate: OfflineCollectionNewsViewDelegate?
  private let coordinator: OfflineCollectionNewsCoordinator

  init(model: OfflineCollectionNewsModel, delegate: OfflineCollectionNewsViewDelegate?, coordinator: OfflineCollectionNewsCoordinator) {
    self.model = model
    self.delegate = delegate
    self.coordinator = coordinator
  }
}

extension OfflineCollectionNewsController: OfflineCollectionNewsViewDataSource {
  func provideObject(at index: IndexPath) -> NewsViewModel {
    return model.object(index.row)
  }

  var count: Int {
    return model.count()
  }
}

// MARK: - OfflineCollectionNewsControllerDelegate
extension OfflineCollectionNewsController: OfflineCollectionNewsControllerDelegate {
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

// MARK: - OfflineCollectionNewsViewDelegate
extension OfflineCollectionNewsController: OfflineCollectionNewsModelOutput {
  func dataLoadSuccess() {
    delegate?.updateUI(withNotFoundNewsView: model.isModelEmpty)
  }

  func dataRemovedSuccess() {
    guard let index = indexPath else { return }
    delegate?.updateUIWithRemoveCellAt(index: index, withNotFoundNewsView: model.isModelEmpty)
  }

  func dataLoadFailed() {
    delegate?.displayAlert(message: R.string.localizable.errorMessagesNoObject())
  }

  func dataRemovedFailed() {
    delegate?.displayAlert(message: R.string.localizable.errorMessagesErrorRemoving())
  }
}
