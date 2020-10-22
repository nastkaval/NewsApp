//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let di = DependeciesContainer()
    di.register(type: ApiManagerProtocol.self, name: "ApiManager", service: ApiManager.shared)
    di.register(type: DatabaseProtocol.self, name: "DatabaseManager", service: DatabaseManager.shared)

    let window = UIWindow(frame: UIScreen.main.bounds)
    var navigationController = UINavigationController()
    navigationController = UINavigationController(rootViewController: NewsViewCoordinator().instantiate(di: di))
    navigationController.navigationBar.isHidden = true
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window

    return true
  }
}
