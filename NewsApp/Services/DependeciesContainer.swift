//
//  Container.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/21/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class DependeciesContainer {
  private var dependecies: [DependencyKey: Any] = [:]

  func register<T>(type: T.Type, service: Any) {
    let dependencyKey = DependencyKey(type: type)
    dependecies[dependencyKey] = service
  }

  func resolve<T>(type: T.Type) -> T {
    let dependencyKey = DependencyKey(type: type)
    return dependecies[dependencyKey] as! T //?
  }
}
