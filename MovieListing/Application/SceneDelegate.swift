//
//  SceneDelegate.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		MovieListBuilder.build { [weak self] viewController in
			guard let windowScene = (scene as? UIWindowScene) else { return }
			let window = UIWindow(windowScene: windowScene)
			let navigationController = UINavigationController(rootViewController: viewController)
			window.rootViewController = navigationController
			self?.window = window
			self?.window?.makeKeyAndVisible()
		}
	}
}
