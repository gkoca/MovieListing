//
//  MovieListBuilder.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import UIKit

class MovieListBuilder: BaseBuilder {

	static var presentationModel: MovieListPresentationModel?

	class func build(completion: @escaping ((MovieListViewController) -> Void)) {
		let movieListBusinessModel = MovieListBusinessModel()
		let movieDetailBusinessModel = MovieDetailBusinessModel()
		presentationModel = MovieListPresentationModel(movieListBusinessModel: movieListBusinessModel,
														   movieDetailBusinessModel: movieDetailBusinessModel)
		presentationModel?.loadScene { viewController in
			completion(viewController)
		}
	}
}
