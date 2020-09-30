//
//  DetailesViewCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class DetailesViewCoordinator {
  func instantiate(news: ViewModel) -> DetailesView {
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.detailesView.identifier) as! DetailesView
    let model = DetailesModel(dependency: ModelDependency(), news: news)
    let controller = DetailesController(view: view, model: model, output: view)
    view.output = controller
    view.input = controller
    return view
  }
}
