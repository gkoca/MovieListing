//
//  Session.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 26.01.2021.
//

import Foundation

class Session {
	static let shared = Session()

	var session: URLSession
	var timeout: TimeOut {
		didSet {
			self.session.configuration.timeoutIntervalForRequest = timeout.request
			self.session.configuration.timeoutIntervalForResource = timeout.resource
		}
	}

	required init() {
		let configuration = URLSession.shared.configuration
		timeout = TimeOut(request: 30, resource: 30)
		self.session = URLSession(configuration: configuration)
	}

	struct TimeOut {
		var request: TimeInterval
		var resource: TimeInterval
	}
}
