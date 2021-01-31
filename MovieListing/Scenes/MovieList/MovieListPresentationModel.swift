//
//  MovieListPresentationModel.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import UIKit

final class MovieListPresentationModel: BasePresentationModel {

	weak var viewController: MovieListViewControllerProtocol? {
		get {
			return self.baseViewController as? MovieListViewControllerProtocol
		}
		set {
			self.baseViewController = newValue
		}
	}
	var router: MovieListRouterProtocol? {
		get {
			return self.baseRouter as?  MovieListRouterProtocol
		}
		set {
			self.baseRouter = newValue
		}
	}
	var sceneLoadingHandler: (() -> Void)?

	var movieListBusinessModel: MovieListBusinessModelProtocol?
	var movieDetailBusinessModel: MovieDetailBusinessModelProtocol?

	var items: [MovieListItem] = []
	var filteredItems: [MovieListItem] = []
	var currentPage: Int = 1
	var totalPageCount: Int = Int.max
	var sceneDidLoad = false

	// MARK: - initialize
	init(movieListBusinessModel: MovieListBusinessModelProtocol,
		 movieDetailBusinessModel: MovieDetailBusinessModelProtocol) {
		super.init()
		self.movieListBusinessModel = movieListBusinessModel
		self.movieDetailBusinessModel = movieDetailBusinessModel
		self.movieListBusinessModel?.delegate = self
		self.movieDetailBusinessModel?.delegate = self
	}

	func loadScene(completion: @escaping ((MovieListViewController) -> Void)) {
		let storyBoard = UIStoryboard(name: "MovieList", bundle: nil)
		let viewController: MovieListViewController = storyBoard.instantiateViewController()
		viewController.presentationModel = self
		viewController.loadViewIfNeeded()
		let router = MovieListRouter(viewController: viewController)
		self.viewController = viewController
		self.router = router
		sceneLoadingHandler = {
			completion(viewController)
		}
		loadList()
	}
}

// MARK: - MovieListPresentationModelProtocol methods
extension MovieListPresentationModel: MovieListPresentationModelProtocol {
	func loadList() {
		if totalPageCount >= currentPage {
			movieListBusinessModel?.fetchPopularMovieList(page: currentPage)
		}
	}

	func search(term: String) {
		filteredItems = items.filter {
			$0.title?.range(of: term, options: [.diacriticInsensitive, .caseInsensitive]) != nil
		}
		viewController?.handleOutput(.didLoadItems)
	}

	func goToMovie(with id: Int) {
		movieDetailBusinessModel?.fetch(with: id)
	}

	func navigate(_ route: MovieListRoutes) {
		router?.navigate(route)
	}
}

// Conform businessModelDelegates
// MARK: - BusinessModelDelegate methods
extension MovieListPresentationModel: MovieListBusinessModelDelegate {
	func handleOutput(_ output: MovieListBusinessModelOutput) {
		switch output {
		case .fetched(let list, let page, let totalPageCount):
			if currentPage != page + 1 {
				currentPage = page + 1
				if sceneDidLoad {
					items.append(contentsOf: list)
				} else {
					items = list
					self.totalPageCount = totalPageCount
					sceneDidLoad = true
					sceneLoadingHandler?()
				}
				viewController?.handleOutput(.didLoadItems)
			}
		}
	}
}
extension MovieListPresentationModel: MovieDetailBusinessModelDelegate {
	func handleOutput(_ output: MovieDetailBusinessModelOutput) {
		switch output {
		case .fetched(let details):
			navigate(.detail(model: details, delegate: self))
		}
	}
}

extension MovieListPresentationModel: MovieDetailSceneDelegate {
	func favoriteStatusChanged(id: Int, isFavorite: Bool) {
		viewController?.handleOutput(.favoriteStatusChanged)
	}
}
