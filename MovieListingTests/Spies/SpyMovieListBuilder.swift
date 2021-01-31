//
//  SpyMovieListBuilder.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import Foundation
@testable import MovieListing

final class SpyMovieListBuilder: MovieListBuilder {
	override class func build(completion: @escaping ((MovieListViewController) -> Void)) {
		let movieListBusinessModel = SpyMovieListBusinessModel()
		let movieDetailBusinessModel = SpyMovieDetailBusinessModel()
		presentationModel = MovieListPresentationModel(movieListBusinessModel: movieListBusinessModel,
														   movieDetailBusinessModel: movieDetailBusinessModel)
		presentationModel?.loadScene { viewController in
			completion(viewController)
		}
	}
}
