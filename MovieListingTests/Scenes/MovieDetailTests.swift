//
//  MovieDetailTests.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import XCTest
@testable import MovieListing

class MovieDetailTests: XCTestCase, MovieDetailSceneDelegate {

	var sutViewController: MovieDetailViewController?
	var sutPresentationModel: MovieDetailPresentationModel?

	override func setUp() {
		super.setUp()

		guard let detail: MovieDetail = JSONLoader.load(from: "detail") else {
			XCTAssert(false)
			return
		}
		FavoritesManager.shared.removeFromFavorites(id: 464052)
		let semaphore = DispatchSemaphore(value: 0)
		MovieDetailBuilder.build(model: detail, delegate: self) { troll in
			self.sutViewController = troll
			self.sutPresentationModel = troll.presentationModel as? MovieDetailPresentationModel
			let navigationController = UINavigationController(rootViewController: self.sutViewController!)
			UIApplication.shared.windows.first?.rootViewController = navigationController
			_ = self.sutViewController?.view
			semaphore.signal()
		}
		semaphore.wait()
	}

	func testScene() {
		XCTAssertNotNil(sutViewController)
		XCTAssertNotNil(sutPresentationModel)
	}

	func testController() {
		XCTAssertEqual(sutViewController?.titleLabel.text, "Wonder Woman 1984")

		XCTAssertEqual(sutViewController?.descriptionLabel.text,
					   "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah.")

		XCTAssertEqual(sutViewController?.voteCountLabel.text, "Total Vote Count: 3186")

		XCTAssertEqual(sutViewController?.voteAverageLabel.text, "Vote Average: 7.1")
		XCTAssertEqual(sutViewController?.releaseDateLabel.text, "Release Date: 16.12.2020")
		XCTAssertEqual(sutViewController?.title, "Content Detail")
		XCTAssertNotNil(sutViewController?.backgroundImageView.image)
		XCTAssertNotNil(sutViewController?.posterImageView.image)

		let config = UIImage.SymbolConfiguration(weight: .light)
		let image = sutViewController?.navigationItem.rightBarButtonItem?.image
		XCTAssertEqual(image, UIImage(systemName: "star", withConfiguration: config))
	}

	func testFavoriteActions() {

		currentFavoriteStatus = (464052, sutViewController?.isFavorite ?? false)
		let config = UIImage.SymbolConfiguration(weight: .light)
		let image = sutViewController?.navigationItem.rightBarButtonItem?.image
		XCTAssertEqual(image, UIImage(systemName: "star", withConfiguration: config))
		XCTAssertEqual(currentFavoriteStatus?.id, 464052)
		XCTAssertEqual(currentFavoriteStatus?.isFavorite, false)

		sutViewController?.rightBarButtonAction()

		let image2 = sutViewController?.navigationItem.rightBarButtonItem?.image
		XCTAssertEqual(image2, UIImage(systemName: "star.fill", withConfiguration: config))
		XCTAssertEqual(currentFavoriteStatus?.id, 464052)
		XCTAssertEqual(currentFavoriteStatus?.isFavorite, true)

		sutViewController?.rightBarButtonAction()

		let image3 = sutViewController?.navigationItem.rightBarButtonItem?.image
		XCTAssertEqual(image3, UIImage(systemName: "star", withConfiguration: config))
		XCTAssertEqual(currentFavoriteStatus?.id, 464052)
		XCTAssertEqual(currentFavoriteStatus?.isFavorite, false)

	}

	var currentFavoriteStatus: (id: Int, isFavorite: Bool)?
	func favoriteStatusChanged(id: Int, isFavorite: Bool) {
		currentFavoriteStatus = (id, isFavorite)
	}
}
