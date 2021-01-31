//
//  main.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import UIKit

// If we have a TestingAppDelegate (i.e. we're running unit tests), use that to avoid executing initialisation code in AppDelegate
let appDelegateClass: AnyClass = NSClassFromString("TestAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
