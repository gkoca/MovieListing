//
//  JSONLoader.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import Foundation

final class JSONLoader {
	static func load<T: Decodable>(from file: String) -> T? {
		if let path = Bundle(for: JSONLoader.self).path(forResource: file, ofType: "json"),
		   let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
			do {
				let decoder = JSONDecoder()
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				decoder.dateDecodingStrategy = .formatted(dateFormatter)
				let response = try decoder.decode(T.self, from: data)
				return response
			} catch {
				return nil
			}
		} else {
			return nil
		}
	}
}
