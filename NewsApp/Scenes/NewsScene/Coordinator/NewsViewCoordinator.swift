//
//  Coordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

class NewsViewCoordinator {
  private let dependencyContainer: DependeciesContainer
  private weak var viewController: UIViewController?

  init(dependencyContainer: DependeciesContainer) {
    self.dependencyContainer = dependencyContainer
  }

  func setRootViewController(callback: ((UIViewController) -> Void)) {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.newsView.identifier) as! NewsView
    viewController = view
    let model = NewsModel(loadService: dependencyContainer.resolve(type: ApiManagerProtocol.self, name: "ApiManager"))
    let controller = NewsController(model: model, output: view, coordinator: self)
    view.output = controller
    view.input = controller
    model.output = controller
    callback(view)
  }

  func openDetailesNews(newsModel: NewsViewModel) {
    DetailesViewCoordinator(dependencyContainer: dependencyContainer, delegate: self).show(news: newsModel) { view in
      self.viewController?.present(view, animated: true)
    }
  }

  func closeDetailesNews() {
    self.viewController?.dismiss(animated: true)
  }

  func openOfflineCollectionNews() {
    OfflineCollectionNewsCoordinator(dependencyContainer: dependencyContainer, delegate: self).show { view in
      self.viewController?.navigationController?.pushViewController(view, animated: true)
    }
  }

  func closeOfflineCollectionNews() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
}
