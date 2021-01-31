//
//  MovieListTests.swift
//  MovieListingTests
//
//  Created by Gökhan KOCA on 31.01.2021.
//

import XCTest
@testable import MovieListing

class MovieListTests: XCTestCase {

	var listBusinessModel: SpyMovieListBusinessModel?
	var detailBusinessModel: SpyMovieDetailBusinessModel?
	var router: SpyMovieListRouter?

	var sutPresentationModel: MovieListPresentationModel?
	var sutViewController: MovieListViewController?

	override func setUp() {
		super.setUp()
		let semaphore = DispatchSemaphore(value: 0)
		SpyMovieListBuilder.build { (troll) in
			self.sutViewController = troll
			self.sutPresentationModel = troll.presentationModel as? MovieListPresentationModel
			self.listBusinessModel = self.sutPresentationModel?.movieListBusinessModel as? SpyMovieListBusinessModel
			self.detailBusinessModel = self.sutPresentationModel?.movieDetailBusinessModel as? SpyMovieDetailBusinessModel
			self.router = SpyMovieListRouter(viewController: troll)
			self.sutPresentationModel?.router = self.router
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
		XCTAssertNotNil(listBusinessModel)
		XCTAssertNotNil(detailBusinessModel)
		XCTAssertNotNil(sutPresentationModel?.router)
	}

	func testController() {
		XCTAssertNotNil(sutViewController?.view)
		XCTAssertNotNil(sutViewController?.collectionView)
		let searchController = sutViewController?.navigationItem.searchController
		XCTAssertNotNil(searchController)
		let rightButton = sutViewController?.navigationItem.rightBarButtonItem
		XCTAssertNotNil(rightButton)
		XCTAssertEqual(sutViewController?.title, "Contents")
	}

	func testCollectionView() {
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))

		XCTAssertNotNil(sutViewController?.collectionView.delegate)
		XCTAssertNotNil(sutViewController?.collectionView.dataSource)
		XCTAssertEqual(sutViewController?.collectionView.numberOfSections, 1)
		XCTAssertEqual(sutViewController?.collectionView.numberOfItems(inSection: 0), 20)
		XCTAssertNotEqual(sutViewController?.collectionView.visibleCells.count, 0)
		XCTAssertEqual(sutViewController?.currentLayoutStyle, .list)

		let layout = sutViewController?.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		XCTAssertEqual(layout?.scrollDirection, .vertical)
		XCTAssertEqual(layout?.sectionInset, UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
		XCTAssertEqual(layout?.minimumInteritemSpacing, 0)
		XCTAssertEqual(layout?.minimumLineSpacing, 8)

		let width = UIScreen.main.bounds.width - 16
		let height = width * 281 / 500
		XCTAssertEqual(layout?.itemSize, CGSize(width: width, height: height))
	}

	func testLayoutChange() {
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))

		XCTAssertEqual(sutViewController?.currentLayoutStyle, .list)
		var layout = sutViewController?.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		XCTAssertEqual(layout?.scrollDirection, .vertical)
		XCTAssertEqual(layout?.sectionInset, UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
		XCTAssertEqual(layout?.minimumInteritemSpacing, 0)
		XCTAssertEqual(layout?.minimumLineSpacing, 8)

		let width = UIScreen.main.bounds.width - 16
		let height = width * 281 / 500
		XCTAssertEqual(layout?.itemSize, CGSize(width: width, height: height))

		let config = UIImage.SymbolConfiguration(weight: .light)
		let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
		XCTAssertEqual(sutViewController?.navigationItem.rightBarButtonItem?.image, image)

		sutViewController?.rightBarButtonAction()
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))

		layout = sutViewController?.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		let image2 = UIImage(systemName: "list.bullet", withConfiguration: config)
		XCTAssertEqual(sutViewController?.navigationItem.rightBarButtonItem?.image, image2)
		XCTAssertEqual(self.sutViewController?.currentLayoutStyle, .grid)

		XCTAssertEqual(layout?.scrollDirection, .vertical)
		XCTAssertEqual(layout?.sectionInset, UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
		XCTAssertEqual(layout?.minimumInteritemSpacing, 0)
		XCTAssertEqual(layout?.minimumLineSpacing, 16)
		let width2 = (UIScreen.main.bounds.width - 32) / 2
		let height2 = width2 * 750 / 500
		XCTAssertEqual(layout?.itemSize, CGSize(width: width2, height: height2))

		sutViewController?.rightBarButtonAction()
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))

		XCTAssertEqual(sutViewController?.currentLayoutStyle, .list)
		layout = sutViewController?.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		XCTAssertEqual(layout?.scrollDirection, .vertical)
		XCTAssertEqual(layout?.sectionInset, UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
		XCTAssertEqual(layout?.minimumInteritemSpacing, 0)
		XCTAssertEqual(layout?.minimumLineSpacing, 8)

		let width3 = UIScreen.main.bounds.width - 16
		let height3 = width3 * 281 / 500
		XCTAssertEqual(layout?.itemSize, CGSize(width: width3, height: height3))

		let image3 = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
		XCTAssertEqual(sutViewController?.navigationItem.rightBarButtonItem?.image, image3)
	}

	func testCollectionContent() {
		guard let collectionView = sutViewController?.collectionView else {
			XCTAssert(false)
			return
		}
		RunLoop.main.run(until: Date(timeIntervalSinceNow: 1))
		let cell1 = sutViewController?.collectionView(
			collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? MovieItemCollectionViewCell
		let cell2 = sutViewController?.collectionView(
			collectionView, cellForItemAt: IndexPath(item: 1, section: 0)) as? MovieItemCollectionViewCell

		XCTAssertEqual(cell1?.titleLabel.text, "Outside the Wire")
		XCTAssertNotNil(cell1?.posterImageView.image)
		XCTAssertTrue(cell1?.favoriteImageView.isHidden ?? false)

		XCTAssertEqual(cell2?.titleLabel.text, "Wonder Woman 1984")
		XCTAssertNotNil(cell2?.posterImageView.image)
		XCTAssertTrue(cell2?.favoriteImageView.isHidden ?? false)
	}

	func testGoToDetail() {
		guard let collectionView = sutViewController?.collectionView else {
			XCTAssert(false)
			return
		}

		sutViewController?.collectionView(collectionView, didSelectItemAt: IndexPath(item: 1, section: 0))

//		let model = router?.passingModel

		XCTAssertEqual(router?.passingModel?.id, 464052)
		XCTAssertEqual(router?.passingModel?.overview, "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah.")
		XCTAssertEqual(router?.passingModel?.poster_path, "/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg")
		XCTAssertEqual(router?.passingModel?.title, "Wonder Woman 1984")
		XCTAssertEqual(router?.passingModel?.vote_average, 7.1)
		XCTAssertEqual(router?.passingModel?.vote_count, 3186)
		XCTAssertEqual(router?.passingModel?.release_date?.timeIntervalSince1970, 1608066000)

		XCTAssertNotNil(router?.passingDelegate as? MovieListPresentationModel)
	}
}
