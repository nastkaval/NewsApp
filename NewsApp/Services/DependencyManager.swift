//
//  DependencyManager.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/22/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class DependencyManager {
  func buildDependencyContainer() -> DependeciesContainer {
    let dependencyContainer = DependeciesContainer()
    dependencyContainer.register(type: ApiManagerProtocol.self, service: ApiManager())
    dependencyContainer.register(type: DatabaseProtocol.self, service: DatabaseManager()) //?

    return dependencyContainer
  }
}
