//
//  DetailesViewCoordinator.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit
import RealmSwift

class DetailesViewCoordinator {
  func instantiate(news: NewsViewModel) {
    // swiftlint:disable force_cast
    let view = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.detailesView.identifier) as! DetailesView
    let di = DependeciesContainer()
    di.register(type: DatabaseProtocol.self, name: "DatabaseManager", service: DatabaseManager.shared)
    guard let dependency = di.resolve(type: DatabaseProtocol.self, name: "DatabaseManager") else { return }
    let model = DetailesModel(loadService: dependency, news: news)
    let controller = DetailesController(model: model, output: view)
    model.output = controller
    view.output = controller
    view.input = controller

    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    window?.rootViewController?.present(view, animated: true)
  }
}
