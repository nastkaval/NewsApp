//
//  Coordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

class NewsViewCoordinator {
  func instantiate() -> NewsView {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.newsView.identifier) as! NewsView
    let model = NewsModel(dependency: ModelDependency())
    let controller = NewsController(model: model, output: view)
    view.output = controller
    view.input = controller
    model.output = controller
    return view
  }
}
