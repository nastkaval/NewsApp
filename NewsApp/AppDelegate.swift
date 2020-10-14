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
  var navigationController: UINavigationController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let newsView = NewsViewCoordinator().instantiate()

    let window = UIWindow(frame: UIScreen.main.bounds)
    navigationController = UINavigationController(rootViewController: newsView)
    navigationController?.navigationBar.isHidden = true
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    self.window = window
    return true
  }
}
