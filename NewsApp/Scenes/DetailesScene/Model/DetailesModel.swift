//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class DetailesModel {
  private var news: ViewModel
  private let databaseManager: DatabaseProtocol

  init(databaseManager: DatabaseProtocol, news: ViewModel) {
    self.databaseManager = databaseManager
    self.news = news
  }

  convenience init(dependency: ModelDependencyProtocol, news: ViewModel) {
    self.init(databaseManager: dependency.databaseManager, news: news)
  }
}

extension DetailesModel {
  func object() -> ViewModel {
    return news
  }
}
