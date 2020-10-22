//
//  Scene.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

enum Scene {
  case news
  case details
}

//extension Scene {
//  func container() -> DependeciesContainer {
//    let diContainer = DependeciesContainer.shared
//
//    switch self {
//    case .news:
//      diContainer.register(type: ApiManagerProtocol.self, name: "ApiManager", service: ApiManager.shared)
//      guard let container = diContainer.resolve(type: ApiManagerProtocol.self, name: "ApiManager") else {
//        fatalError("No suitable dependency found")
//      }
//      return container
//      case .details:
//        diContainer.register(type: DatabaseProtocol.self, name: "DatabaseManager", service: DatabaseManager.shared)
//        guard let container = diContainer.resolve(type: DatabaseProtocol.self, name: "DatabaseManager") else {
//          fatalError("No suitable dependency found")
//        }
//        return container
//    }
//  }
//}
