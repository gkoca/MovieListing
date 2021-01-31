//
//  MovieDetailBusinessModel.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import Foundation

protocol MovieDetailBusinessModelProtocol: BaseBusinessModelProtocol {
	var delegate: MovieDetailBusinessModelDelegate? { get set }
	func fetch(with id: Int)
}

protocol MovieDetailBusinessModelDelegate: BaseBusinessModelDelegate {
	func handleOutput(_ output: MovieDetailBusinessModelOutput)
}

enum MovieDetailBusinessModelOutput {
	case fetched(detail: MovieDetail)
}

final class MovieDetailBusinessModel: BaseBusinessModel {
	weak var delegate: MovieDetailBusinessModelDelegate? {
		get {
			return self.baseDelegate as? MovieDetailBusinessModelDelegate
		}
		set {
			self.baseDelegate = newValue
		}
	}
}

// MARK: - MovieDetailBusinessModelProtocol methods
extension  MovieDetailBusinessModel: MovieDetailBusinessModelProtocol {
	func fetch(with id: Int) {
		API.detail(id: id).call { (response: MovieDetail?, error) in
			guard let model = response else {
				self.delegate?.didFailure(errorText: error?.localizedDescription ?? "Unknown error!")
				return
			}
			self.delegate?.handleOutput(.fetched(detail: model))
		}
	}
}
