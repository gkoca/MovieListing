//
//  MovieDetailBuilder.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 27.01.2021.
//

import UIKit

final class MovieDetailBuilder: BaseBuilder {

	static var presentationModel: MovieDetailPresentationModel?

	static func build(model: MovieDetail, delegate: MovieDetailSceneDelegate? = nil,
					  completion: @escaping ((MovieDetailViewController) -> Void)) {
		presentationModel = MovieDetailPresentationModel(model: model)
		presentationModel?.delegate = delegate
		presentationModel?.loadScene { viewController in
			completion(viewController)
			presentationModel = nil
		}
	}
}
