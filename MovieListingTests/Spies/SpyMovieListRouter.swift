//
//  SpyMovieListRouter.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import Foundation
@testable import MovieListing

final class SpyMovieListRouter: MovieListRouter {

	var passingModel: MovieDetail?
	weak var passingDelegate: MovieDetailSceneDelegate?
	override func navigate(_ route: MovieListRoutes) {
		switch route {
		case .detail(let model, let delegate):
			passingModel = model
			passingDelegate = delegate
		}
	}
}
