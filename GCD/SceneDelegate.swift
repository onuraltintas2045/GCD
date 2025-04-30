//
//  SceneDelegate.swift
//  GCD
//
//  Created by Onur Altintas on 30.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = GCDViewController()
        self.window = window
    }


}

