//
//  MovieListBusinessModel.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import Foundation

protocol MovieListBusinessModelProtocol: BaseBusinessModelProtocol {
	var delegate: MovieListBusinessModelDelegate? { get set }
	func fetchPopularMovieList(page: Int)
}

protocol MovieListBusinessModelDelegate: BaseBusinessModelDelegate {
	func handleOutput(_ output: MovieListBusinessModelOutput)
}

enum MovieListBusinessModelOutput {
	case fetched(list: [MovieListItem], page: Int, totalPageCount: Int)
}

final class MovieListBusinessModel: BaseBusinessModel {

	weak var delegate: MovieListBusinessModelDelegate? {
		get {
			return self.baseDelegate as? MovieListBusinessModelDelegate
		}
		set {
			self.baseDelegate = newValue
		}
	}
}

// MARK: - MovieListBusinessModelProtocol methods
extension  MovieListBusinessModel: MovieListBusinessModelProtocol {
	func fetchPopularMovieList(page: Int) {
		API.popular(page: page).call(shoudShowLoading: false) { [weak self] (response: MovieList?, error) in
			guard let list = response?.results, let totalPageCount = response?.total_pages else {
				self?.delegate?.handleOutput(.fetched(list: [], page: page, totalPageCount: 0))
				if let errors = response?.errors {
					let message = errors.joined(separator: "\n")
					self?.delegate?.didFailure(errorText: message)
				} else {
					self?.delegate?.didFailure(errorText: error?.localizedDescription ?? "Unknown error!")
				}
				return
			}
			self?.delegate?.handleOutput(.fetched(list: list, page: page, totalPageCount: totalPageCount))
		}
	}
}
