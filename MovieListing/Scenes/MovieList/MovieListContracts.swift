//
//  MovieListContracts.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import Foundation

// MARK: Presenter
protocol MovieListPresentationModelProtocol: BasePresentationModelProtocol {
	var viewController: MovieListViewControllerProtocol? { get set }
	var movieListBusinessModel: MovieListBusinessModelProtocol? { get set }
	var movieDetailBusinessModel: MovieDetailBusinessModelProtocol? { get set }
	var router: MovieListRouterProtocol? { get set }
	func navigate(_ route: MovieListRoutes)
	var items: [MovieListItem] { get set }
	var filteredItems: [MovieListItem] { get set }
	var currentPage: Int { get set }
	func loadList()
	func search(term: String)
	func goToMovie(with id: Int)
}

enum MovieListPresentationModelOutput {
	case didLoadItems
	case favoriteStatusChanged
}

// MARK: View
protocol MovieListViewControllerProtocol: BaseViewControllerProtocol {
	var presentationModel: MovieListPresentationModelProtocol? { get set }
	func handleOutput(_ output: MovieListPresentationModelOutput)
}
enum LayoutStyle {
	case grid
	case list
}

// MARK: Router
protocol MovieListRouterProtocol: BaseRouterProtocol {
	func navigate(_ route: MovieListRoutes)
}

enum MovieListRoutes {
	case detail(model: MovieDetail, delegate: MovieDetailSceneDelegate?)
}
