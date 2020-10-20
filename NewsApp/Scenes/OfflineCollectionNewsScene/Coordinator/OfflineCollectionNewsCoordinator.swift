//
//  OfflineCollectionNewsCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/6/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class OfflineCollectionNewsCoordinator {
  func instantiate() -> OfflineCollectionNewsView {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.offlineCollectionNewsView.identifier) as! OfflineCollectionNewsView
    let model = OfflineCollectionNewsModel(dependency: ModelDependency())
    let controller = OfflineCollectionNewsController(model: model, output: view)
    model.output = controller
    view.output = controller
    view.input = controller
    return view
  }
}
