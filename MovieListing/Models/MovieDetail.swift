//
//  MovieDetail.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 29.01.2021.
//

import Foundation

struct MovieDetail: Decodable {
	let id: Int?
	let title: String?
	let overview: String?
	let poster_path: String?
	let release_date: Date? // "2019-03-29"
	let vote_average: Double?
	let vote_count: Int?
}
