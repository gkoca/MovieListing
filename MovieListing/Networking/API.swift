//
//  API.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 26.01.2021.
//

import Foundation

enum API: Caller {

	case popular(page: Int)
	case detail(id: Int)

	var apiKey: String {
		return Bundle.main.infoForKey("API_KEY") ?? ""
	}
	var baseURL: URL {
		let baseURLString = Bundle.main.infoForKey("BASE_URL") ?? ""
		return URL(forceString: baseURLString)
	}

	var method: HTTPMethod {
		return .get
	}

	var task: HTTPTask {
		return .requestParameters(parameters: parameters, encoding: .urlEncoding)
	}

	var path: String {
		switch self {
		case .popular:
			return "movie/popular"
		case .detail(let id):
			return "movie/\(id)"
		}
	}

	var parameters: [String: Any] {
		switch self {
		case .popular(let page):
			return ["language": "en-US", "page": page]
		case .detail:
			return ["language": "en-US"]
		}
	}

}
