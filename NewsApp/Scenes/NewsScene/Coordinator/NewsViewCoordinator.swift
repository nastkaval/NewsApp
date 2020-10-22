//
//  Coordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

class NewsViewCoordinator {
  func instantiate(di: DependeciesContainer) -> NewsView {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.newsView.identifier) as! NewsView
    let dependency = di.resolve(type: ApiManagerProtocol.self, name: "ApiManager")
    let model = NewsModel(loadService: dependency as! ApiManagerProtocol)
    let controller = NewsController(model: model, output: view)
    view.output = controller
    view.input = controller
    model.output = controller

    return view
  }
}
