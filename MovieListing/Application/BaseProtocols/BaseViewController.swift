//
//  BaseViewController.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import UIKit

class BaseViewController: UIViewController {

	internal var basePresentationModel: BasePresentationModelProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()
		print("\(String(describing: type(of: self))) \(#function)")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("\(String(describing: type(of: self))) \(#function)")
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("\(String(describing: type(of: self))) \(#function)")
	}

	deinit {
		print("\(String(describing: type(of: self))) \(#function)")
	}
}

extension BaseViewController: BaseViewControllerProtocol {
	func didFailure(errorText: String) {
		print("\(String(describing: type(of: self))) \(#function) text: \(errorText)")
		let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default))
		present(alert, animated: true)
	}

	func hideKeyboard() {
		print("\(String(describing: type(of: self))) \(#function)")
	}
}
