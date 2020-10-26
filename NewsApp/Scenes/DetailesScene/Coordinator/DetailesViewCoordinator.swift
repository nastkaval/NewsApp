//
//  DetailesViewCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import RealmSwift

protocol DetailesViewCoordinatorOutput: AnyObject {
  func closeDetailesView()
}

final class DetailesViewCoordinator {
  private let dependencyContainer: DependeciesContainer
  weak var output: DetailesViewCoordinatorOutput?

  init(dependencyContainer: DependeciesContainer) {
    self.dependencyContainer = dependencyContainer
  }

  func show(news: NewsViewModel, callback: ((UIViewController) -> Void)) {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.detailesView.identifier) as! DetailesView
    let model = DetailesModel(loadService: dependencyContainer.resolve(type: DatabaseProtocol.self, name: "DatabaseManager"), news: news)
    let controller = DetailesController(model: model, output: view, coordinator: self)
    model.output = controller
    view.output = controller
    view.input = controller
    callback(view)
  }

  func hide() {
    output?.closeDetailesView()
  }
}
