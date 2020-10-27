//
//  OfflineCollectionNewsCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/6/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

protocol OfflineCollectionNewsCoordinatorDelegate: AnyObject {
  func closeOfflineCollectionNews()
}
final class OfflineCollectionNewsCoordinator {
  private let dependencyContainer: DependeciesContainer
  weak var delegate: OfflineCollectionNewsCoordinatorDelegate?

  init(dependencyContainer: DependeciesContainer) {
    self.dependencyContainer = dependencyContainer
  }

  func show(_ callback: ((UIViewController) -> Void)) {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.offlineCollectionNewsView.identifier) as! OfflineCollectionNewsView
    let model = OfflineCollectionNewsModel(databaseManager: dependencyContainer.resolve(type: DatabaseProtocol.self))
    let controller = OfflineCollectionNewsController(model: model, delegate: view, coordinator: self)
    model.output = controller
    view.delegate = controller
    callback(view)
  }

  func hide() {
    delegate?.closeOfflineCollectionNews()
  }
}
