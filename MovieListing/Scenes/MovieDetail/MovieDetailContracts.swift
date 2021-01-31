//
//  MovieDetailContracts.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 27.01.2021.
//

import Foundation

// MARK: Presenter
protocol MovieDetailPresentationModelProtocol: BasePresentationModelProtocol {
	var viewController: MovieDetailViewControllerProtocol? { get set }
	var model: MovieDetail { get set }
	func addToFavorite()
	func removeFromFavorite()
}

enum MovieDetailPresentationModelOutput {
	case favoriteStatusChanged(isFavorite: Bool)
}

// MARK: View
protocol MovieDetailViewControllerProtocol: BaseViewControllerProtocol {
	var presentationModel: MovieDetailPresentationModelProtocol? { get set }
	func handleOutput(_ output: MovieDetailPresentationModelOutput)
}

protocol MovieDetailSceneDelegate: class {
	func favoriteStatusChanged(id: Int, isFavorite: Bool)
}
