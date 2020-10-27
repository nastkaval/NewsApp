//
//  Coordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

final class NewsViewCoordinator {
  private let dependencyContainer: DependeciesContainer
  private weak var viewController: UIViewController?

  init(dependencyContainer: DependeciesContainer) {
    self.dependencyContainer = dependencyContainer
  }

  func setRootViewController(callback: ((UIViewController) -> Void)) {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.newsView.identifier) as! NewsView
    viewController = view
    let model = NewsModel(loadService: dependencyContainer.resolve(type: ApiManagerProtocol.self))
    let controller = NewsController(model: model, delegate: view, coordinator: self)
    view.delegate = controller
    model.delegate = controller
    callback(view)
  }

  func openDetailsNews(newsModel: News) {
    let detailsCoordinator = DetailsViewCoordinator(dependencyContainer: dependencyContainer)
    detailsCoordinator.delegate = self
    detailsCoordinator.show(news: newsModel) { view in
      self.viewController?.present(view, animated: true)
    }
  }

  func openOfflineCollectionNews() {
    let offlineCollectionNewsCoordinator = OfflineCollectionNewsCoordinator(dependencyContainer: dependencyContainer)
    offlineCollectionNewsCoordinator.delegate = self
    offlineCollectionNewsCoordinator.show { view in
      self.viewController?.navigationController?.pushViewController(view, animated: true)
    }
  }
}

extension NewsViewCoordinator: DetailsViewCoordinatorDelegate {
  func closeDetailsView() {
    viewController?.dismiss(animated: true)
  }
}

extension NewsViewCoordinator: OfflineCollectionNewsCoordinatorDelegate {
  func closeOfflineCollectionNews() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
