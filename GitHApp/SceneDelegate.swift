//
//  SceneDelegate.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: LinksViewController(networkingService: NetworkingService()))
        window?.makeKeyAndVisible()
    }
}

