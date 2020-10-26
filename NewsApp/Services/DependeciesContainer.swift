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

  func register<T>(type: T.Type, name: String, service: Any) {
    let dependencyKey = DependencyKey(type: type, name: name)
    dependecies[dependencyKey] = service
  }

  func resolve<T>(type: T.Type, name: String) -> T {
    let dependencyKey = DependencyKey(type: type, name: name)
    return dependecies[dependencyKey] as! T //?
  }
}
