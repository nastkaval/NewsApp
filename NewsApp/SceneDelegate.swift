//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Nastassia Kavalchuk on 8/19/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let newsView = NewsViewCoordinator().instantiate()

    let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window.windowScene = windowScene
    window.rootViewController = newsView
    window.makeKeyAndVisible()

    self.window = window
  }
}
