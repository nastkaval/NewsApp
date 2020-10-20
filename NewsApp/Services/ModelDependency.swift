//
//  ModelDependency.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/28/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol ModelDependencyProtocol {
  var apiManager: ApiManagerProtocol { get }
  var databaseManager: DatabaseProtocol { get }
}

class ModelDependency {
  private let apiManagerDependency: ApiManagerProtocol = ApiManager.shared
  private let databaseManagerDependency: DatabaseProtocol = DatabaseManager.shared
}

// MARK: - ModelDependencyProtocol
extension ModelDependency: ModelDependencyProtocol {
  var apiManager: ApiManagerProtocol {
    return apiManagerDependency
  }
  var databaseManager: DatabaseProtocol {
    return databaseManagerDependency
  }
}
