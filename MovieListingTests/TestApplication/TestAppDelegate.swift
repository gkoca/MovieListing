//
//  TestAppDelegate.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import UIKit

@objc(TestAppDelegate)
final class TestAppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		for sceneSession in application.openSessions {
			application.perform(Selector(("_removeSessionFromSessionSet:")), with: sceneSession)
		}
		return true
	}

	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication,
					 configurationForConnecting connectingSceneSession: UISceneSession,
					 options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
		sceneConfiguration.delegateClass = TestSceneDelegate.self
		return sceneConfiguration
	}
}
