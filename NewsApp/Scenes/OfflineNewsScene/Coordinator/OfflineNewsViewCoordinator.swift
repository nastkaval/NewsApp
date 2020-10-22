//
//  OfflineNewsViewCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/6/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class OfflineNewsViewCoordinator {
  func instantiate() {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.offlineNewsView.identifier) as! OfflineNewsView
    let model = OfflineNewsModel(dependency: ModelDependency())
    let controller = OfflineNewsController(model: model, output: view)
    model.output = controller
    view.output = controller
    view.input = controller
  }
}
