//
//  MovieDetailPresentationModel.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 27.01.2021.
//

import UIKit

final class MovieDetailPresentationModel: BasePresentationModel {

	weak var viewController: MovieDetailViewControllerProtocol? {
		get {
			return self.baseViewController as? MovieDetailViewControllerProtocol
		}
		set {
			self.baseViewController = newValue
		}
	}

	var model: MovieDetail
	weak var delegate: MovieDetailSceneDelegate?

	init(model: MovieDetail) {
		self.model = model
		super.init()
	}

	func loadScene(completion: @escaping ((MovieDetailViewController) -> Void)) {
		let storyBoard = UIStoryboard(name: "MovieDetail", bundle: nil)
		let viewController: MovieDetailViewController = storyBoard.instantiateViewController()
		viewController.presentationModel = self
		viewController.loadViewIfNeeded()
		self.viewController = viewController
		completion(viewController)
	}
}

// MARK: - MovieDetailPresentationModelProtocol methods
extension MovieDetailPresentationModel: MovieDetailPresentationModelProtocol {
	func addToFavorite() {
		if let id = model.id {
			FavoritesManager.shared.addToFavorites(id: id)
			viewController?.handleOutput(.favoriteStatusChanged(isFavorite: true))
			delegate?.favoriteStatusChanged(id: id, isFavorite: true)
		}
	}

	func removeFromFavorite() {
		if let id = model.id {
			FavoritesManager.shared.removeFromFavorites(id: id)
			viewController?.handleOutput(.favoriteStatusChanged(isFavorite: false))
			delegate?.favoriteStatusChanged(id: id, isFavorite: false)
		}
	}
}
