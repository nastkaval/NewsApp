//
//  DetailsViewCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import RealmSwift

final class DetailsViewCoordinator {
  private let dependencyContainer: DependeciesContainer
  weak var delegate: DetailsViewCoordinatorDelegate?

  init(dependencyContainer: DependeciesContainer) {
    self.dependencyContainer = dependencyContainer
  }

  func show(news: News, callback: ((UIViewController) -> Void)) {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.detailsView.identifier) as! DetailsView
    let model = DetailsModel(loadService: dependencyContainer.resolve(type: DatabaseProtocol.self), news: news)
    let controller = DetailsController(model: model, view: view, output: self)
    model.delegate = controller
    view.controller = controller
    callback(view)
  }

  func hide() {
    delegate?.closeDetailsView()
  }
}