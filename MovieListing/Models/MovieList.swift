//
//  MovieList.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 26.01.2021.
//

struct MovieList: Decodable {
	let page: Int?
	let results: [MovieListItem]?
	let total_pages: Int?
	let total_results: Int?
	let errors: [String]?
}
