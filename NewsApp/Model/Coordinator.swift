//
//  Coordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

class Coordinator {
  func instantiate() -> NewsView? {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let view = mainStoryboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView
    let controller = NewsController()
    let model = NewsModel(dependency: ModelDependency())
    controller.output = view
    controller.model = model
    view?.output = controller
    view?.input = controller
    model.output = controller
    return view
  }
}
