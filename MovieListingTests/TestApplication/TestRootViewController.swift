//
//  TestRootViewController.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import UIKit

final class TestRootViewController: UIViewController {
	override func loadView() {
		let label = UILabel()
		label.text = "Running Unit Tests..."
		label.textAlignment = .center
		label.textColor = .white
		view = label
	}
}
