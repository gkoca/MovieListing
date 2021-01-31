//
//  Extensions.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 26.01.2021.
//

import UIKit

extension Bundle {
	func infoForKey(_ key: String) -> String? {
		return (infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
	}
}

extension URL {
	init(forceString string: String) {
		guard let url = URL(string: string) else { fatalError("Could not init URL '\(string)'") }
		self = url
	}
}

extension UIImageView {
	func load(from path: String, contentMode: UIView.ContentMode = .scaleAspectFit, placeholder: String? = nil) {
		self.contentMode = contentMode
		if path.isEmpty {
			print("IMAGE -> Path is empty")
			if let placeholder = placeholder {
				print("IMAGE -> Returning placeholder")
				self.image = UIImage(named: placeholder)
				return
			}
			print("IMAGE -> Returning nil")
			return
		}
		if let image = ImageRepository.shared.getImage(with: path) {
			self.image = image
			return
		}

		let baseImageURLString = Bundle.main.infoForKey("BASE_IMAGE_URL") ?? ""
		let url = URL(forceString: baseImageURLString).appendingPathComponent(path)
		print("IMAGE -> downloading from \(url.absoluteString)")
		Session.shared.session.dataTask(with: url) {(data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
			else {
				if let placeholder = placeholder {
					DispatchQueue.main.async { [weak self] in
						print("IMAGE -> download failed. Returning placeholder")
						self?.image = UIImage(named: placeholder)
					}
				}
				return
			}
			print("IMAGE -> download success. size: \(data.count)")
			ImageRepository.shared.cache(image: image, with: path)
			DispatchQueue.main.async { [weak self] in
				self?.image = image
			}
		}.resume()
	}
}

extension UserDefaults {
	func array<T>(for key: String) -> [T]? {
		guard let returnValue: [T] = UserDefaults.standard.object(forKey: key) as? [T] else {
			return nil
		}
		return returnValue
	}
}
