//
//  SpyMovieListBusinessModel.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import Foundation
@testable import MovieListing

class SpyMovieListBusinessModel: MovieListBusinessModelProtocol {
	weak var baseDelegate: BaseBusinessModelDelegate?

	weak var delegate: MovieListBusinessModelDelegate? {
		get {
			return self.baseDelegate as? MovieListBusinessModelDelegate
		}
		set {
			self.baseDelegate = newValue
		}
	}

	func fetchPopularMovieList(page: Int) {
		switch page {
		case 1:
			if let response: MovieList = JSONLoader.load(from: "page1"),
			   let totalPageCount = response.total_pages,
			   let list = response.results {
				delegate?.handleOutput(.fetched(list: list, page: page, totalPageCount: totalPageCount))
				return
			}
		case 2:
			if let response: MovieList = JSONLoader.load(from: "page2"),
			   let totalPageCount = response.total_pages,
			   let list = response.results {
				delegate?.handleOutput(.fetched(list: list, page: page, totalPageCount: totalPageCount))
				return
			}
		case 3:
			delegate?.handleOutput(.fetched(list: [], page: page, totalPageCount: Int.max))
		default:
			break
		}
		self.delegate?.didFailure(errorText: "Unknown error!")
		delegate?.handleOutput(.fetched(list: [], page: page, totalPageCount: Int.max))
	}
}
