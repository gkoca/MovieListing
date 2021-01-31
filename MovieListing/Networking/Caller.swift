//
//  Caller.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 26.01.2021.
//

import Foundation

private var requestCounter: Int = 0

protocol ParameterEncoder {
	func encode(urlRequest: inout URLRequest, with parameters: [String: Any])
}

struct URLParameterEncoder: ParameterEncoder {
	func encode(urlRequest: inout URLRequest, with parameters: [String: Any]) {
		guard let url = urlRequest.url else { fatalError("Missing URL") }
		if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
			urlComponents.queryItems = [URLQueryItem]()
			parameters.forEach {
				let queryItem = URLQueryItem(name: $0, value: "\($1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
				urlComponents.queryItems?.append(queryItem)
			}
			urlRequest.url = urlComponents.url
		}
	}
}

public enum ParameterEncoding {

	case urlEncoding

	public func encode(urlRequest: inout URLRequest, parameters: [String: Any]?, apiKey: String) {
		switch self {
		case .urlEncoding:
			guard var urlParameters = parameters else { return }
			urlParameters["api_key"] = apiKey
			URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
		}
	}
}

enum HTTPMethod: String {
	case get = "GET"
}

public enum HTTPTask {
	case requestParameters(parameters: [String: Any]?, encoding: ParameterEncoding)
}

protocol Caller {
	var apiKey: String { get }
	var baseURL: URL { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var parameters: [String: Any] { get }
	var task: HTTPTask { get }
}

extension Caller {
	public func call<T: Decodable>(shoudShowLoading: Bool = true, completion: @escaping (T?, Error?) -> Void) {
		call(createRequest(), shoudShowLoading: shoudShowLoading, completion: completion)
	}

	private func createRequest() -> URLRequest {
		var request = URLRequest(url: baseURL.appendingPathComponent(path))
		request.httpMethod = method.rawValue
		request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

		switch task {
		case .requestParameters(let parameters, let encoding):
			encoding.encode(urlRequest: &request, parameters: parameters, apiKey: apiKey)
		}
		return request
	}

	private func call<T: Decodable>(_ urlRequest: URLRequest, shoudShowLoading: Bool,
									completion: @escaping ((T?, Error?) -> Void)) {
		if shoudShowLoading {
			Loading.show()
		}
		callData(urlRequest) { (data, error) in
			if shoudShowLoading {
				Loading.hide()
			}
			if let data = data {
				do {
					let decoder = JSONDecoder()
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyy-MM-dd"
					decoder.dateDecodingStrategy = .formatted(dateFormatter)
					let response = try decoder.decode(T.self, from: data)
					completion(response, nil)
				} catch {
					completion(nil, error)
				}
			} else {
				completion(nil, error)
			}
		}
	}

	private func callData(_ urlRequest: URLRequest, completion: @escaping ((Data?, Error?) -> Void)) {
		let requesting = requestCounter
		requestCounter += 1
		#if DEBUG
		print("\n")
		print("<----- REQUESTING \(String(format: "%06d", requesting))----->")
		print("URL: \(urlRequest.url?.absoluteString ?? "")")
		print("<-------- REQUESTING -------->")
		print("\n")
		#endif

		let task = Session.shared.session
			.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
				DispatchQueue.main.async {
					self.printRequest(urlRequest.url?.absoluteString ?? "", counter: requesting)
					self.printResponse(data, counter: requesting)
					completion(data, error)
				}
			})
		task.resume()
	}

	private func printRequest(_ url: String, counter: Int) {
		#if DEBUG
		print("\n")
		print("<---- REQUESTED \(String(format: "%06d", counter)) --->")
		print("Endpoint: \(url)")
		print("<------- REQUESTED ------->")
		print("\n")
		#endif
	}

	private func printResponse(_ data: Data?, counter: Int) {
		#if DEBUG
		print("\n")
		print("<----- RESPONSE \(String(format: "%06d", counter)) ---->")
		printData(data)
		print("<-------- RESPONSE -------->")
		print("\n")
		#endif
	}

	private func printData(_ data: Data?) {
		if let data = data {
			if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
			   let json = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
			   let string = String(data: json, encoding: .utf8) {
				print(string)
			} else if let string = String(data: data, encoding: .utf8) {
				print(string)
			}
		}
	}
}
