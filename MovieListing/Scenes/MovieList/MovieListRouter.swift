//
//  MovieListRouter.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import UIKit

class MovieListRouter: MovieListRouterProtocol {
	unowned var viewController: UIViewController

	init(viewController: UIViewController) {
		self.viewController = viewController
	}

	func navigate(_ route: MovieListRoutes) {
		switch route {
		case .detail(let model, let delegate):
			MovieDetailBuilder.build(model: model, delegate: delegate) { (detailController) in
				self.viewController.show(detailController, sender: self)
			}
		}
	}
}
