//
//  FavoritesManager.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 29.01.2021.
//

import Foundation

class FavoritesManager {

	static let shared = FavoritesManager()
	var favoriteList = [Int]() {
		didSet {
			UserDefaults.standard.setValue(favoriteList, forKey: "favoriteList")
			UserDefaults.standard.synchronize()
		}
	}

	init() {
		favoriteList = UserDefaults.standard.array(for: "favoriteList") ?? []
	}

	func isFavorite(id: Int?) -> Bool {
		guard let id = id else { return false}
		return favoriteList.contains(id)
	}

	func addToFavorites(id: Int) {
		favoriteList.append(id)
	}

	func removeFromFavorites(id: Int) {
		favoriteList.removeAll { $0 == id }
	}
}
