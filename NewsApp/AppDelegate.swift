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
    let dependencyManager = DependencyManager()
    let dependencyContainer = dependencyManager.buildDependencyContainer()

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true

    NewsViewCoordinator(dependencyContainer: dependencyContainer).setRootViewController { view in
      navigationController.viewControllers = [view]
    }

    window.rootViewController = navigationController
    self.window = window

    return true
  }
}
