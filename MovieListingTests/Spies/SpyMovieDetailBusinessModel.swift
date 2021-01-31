//
//  SpyMovieDetailBusinessModel.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import Foundation
@testable import MovieListing

final class SpyMovieDetailBusinessModel: MovieDetailBusinessModelProtocol {

	weak var baseDelegate: BaseBusinessModelDelegate?

	weak var delegate: MovieDetailBusinessModelDelegate? {
		get {
			return self.baseDelegate as? MovieDetailBusinessModelDelegate
		}
		set {
			self.baseDelegate = newValue
		}
	}

	func fetch(with id: Int) {
		switch id {
		case 464052:

			if let response: MovieDetail = JSONLoader.load(from: "detail") {
				delegate?.handleOutput(.fetched(detail: response))
				return
			}
		default:
			break
		}

		self.delegate?.didFailure(errorText: "Unknown error!")
	}
}
