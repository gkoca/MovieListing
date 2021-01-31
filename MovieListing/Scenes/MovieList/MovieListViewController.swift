//
//  MovieListViewController.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 24.01.2021.
//

import UIKit

final class MovieListViewController: BaseViewController {
	var presentationModel: MovieListPresentationModelProtocol? {
		get {
			return self.basePresentationModel as? MovieListPresentationModelProtocol
		}
		set {
			self.basePresentationModel = newValue
		}
	}

	// MARK: - ui controls
	@IBOutlet weak var collectionView: UICollectionView!

	// MARK: - members
	private let searchController = UISearchController(searchResultsController: nil)
	var currentLayoutStyle: LayoutStyle = .list
	private lazy var gridLayout: UICollectionViewFlowLayout = {
		let collectionFlowLayout = UICollectionViewFlowLayout()
		collectionFlowLayout.scrollDirection = .vertical
		collectionFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
		let width = (UIScreen.main.bounds.width - 32) / 2
		let height = width * 750 / 500 // poster size
		collectionFlowLayout.itemSize = CGSize(width: width, height: height)
		collectionFlowLayout.minimumInteritemSpacing = 0
		collectionFlowLayout.minimumLineSpacing = 16
		return collectionFlowLayout
	}()

	private lazy var listLayout: UICollectionViewFlowLayout = {
		let collectionFlowLayout = UICollectionViewFlowLayout()
		collectionFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
		let width = UIScreen.main.bounds.width - 16
		let height = width * 281 / 500 // backdrop size
		collectionFlowLayout.itemSize = CGSize(width: width, height: height)
		collectionFlowLayout.minimumInteritemSpacing = 0
		collectionFlowLayout.minimumLineSpacing = 8
		collectionFlowLayout.scrollDirection = .vertical
		return collectionFlowLayout
	}()

	// MARK: - initialize
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupNavigationBar()
		setupSearchController()
	}

	// MARK: - custom methods
	private func setupUI() {
		title = "Contents"
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(UINib(nibName: "MovieItemCollectionViewCell", bundle: nil),
								forCellWithReuseIdentifier: "movieItem")
		let layoutStyle = currentLayoutStyle == .list ? listLayout : gridLayout
		collectionView.setCollectionViewLayout(layoutStyle, animated: false)
	}

	private func setupNavigationBar() {
		addLayoutStyleButton(for: currentLayoutStyle)
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}

	private func setupSearchController() {
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search by movie name"
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		definesPresentationContext = true
	}

	func isSearching() -> Bool {
		return !(searchController.searchBar.text?.isEmpty ?? true)
	}

	private func switchLayoutStyle() {
		switch currentLayoutStyle {
		case .grid:
			currentLayoutStyle = .list
		case .list:
			currentLayoutStyle = .grid
		}
		addLayoutStyleButton(for: currentLayoutStyle)
	}

	private func addLayoutStyleButton(for layoutStyle: LayoutStyle) {
		navigationItem.rightBarButtonItem = nil
		var image: UIImage!
		let config = UIImage.SymbolConfiguration(weight: .light)
		switch layoutStyle {
		case .grid:
			image = UIImage(systemName: "list.bullet", withConfiguration: config)
		case .list:
			image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
		}
		let rightBarButton = UIBarButtonItem(image: image,
											 style: .plain,
											 target: self,
											 action: #selector(rightBarButtonAction))
		navigationItem.rightBarButtonItem = rightBarButton
	}

	@objc func rightBarButtonAction() {
		self.switchLayoutStyle()
		stopScroll()
		navigationItem.rightBarButtonItem?.isEnabled = false
		collectionView.reloadData()
		let layoutStyle = currentLayoutStyle == .list ? listLayout : gridLayout
		collectionView.startInteractiveTransition(to: layoutStyle) { [weak self] (_, finished) in
			if finished {
				self?.navigationItem.rightBarButtonItem?.isEnabled = true
			}
		}
		collectionView.finishInteractiveTransition()
	}
}

// MARK: - MovieListViewControllerProtocol methods
extension MovieListViewController: MovieListViewControllerProtocol {
	func handleOutput(_ output: MovieListPresentationModelOutput) {
		switch output {
		case .didLoadItems:
			collectionView.reloadData()
		case .favoriteStatusChanged:
			collectionView.reloadData()
		}
	}
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		isSearching() ? presentationModel?.filteredItems.count ?? 0 : presentationModel?.items.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard
			let items = isSearching() ? presentationModel?.filteredItems : presentationModel?.items,
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieItem",
														  for: indexPath) as? MovieItemCollectionViewCell
		else { return UICollectionViewCell() }

		cell.titleLabel.text = items[indexPath.row].title
		cell.favoriteImageView.isHidden = !(FavoritesManager.shared.isFavorite(id: items[indexPath.row].id))

		switch currentLayoutStyle {
		case .grid:
			cell.posterImageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
			cell.state = .grid
			cell.titleLabel.textAlignment = .center
			cell.posterImageView.load(from: items[indexPath.row].poster_path ?? "", placeholder: "placeholderPortrait")
		case .list:
			cell.state = .list
			cell.titleLabel.textAlignment = .left
			cell.posterImageView.load(from: items[indexPath.row].poster_path ?? "",
									  contentMode: .scaleAspectFill, placeholder: "placeholderWide")
			cell.calculateParallax(collectionViewBounds: collectionView.bounds)
		}

		if !isSearching() && indexPath.row == items.count - 4 {
			presentationModel?.loadList()
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let items = isSearching() ? presentationModel?.filteredItems : presentationModel?.items,
		   let id = items[indexPath.row].id {
			presentationModel?.goToMovie(with: id)
		}
		collectionView.deselectItem(at: indexPath, animated: true)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if let cells = collectionView.visibleCells as? [MovieItemCollectionViewCell] {
			for cell in cells {
				cell.calculateParallax(collectionViewBounds: collectionView.bounds)
			}
		}
	}

	func stopScroll() {
		collectionView.setContentOffset(collectionView.contentOffset, animated: false)
	}
}

extension MovieListViewController: UISearchResultsUpdating, UISearchBarDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		if let term = searchController.searchBar.text {
			presentationModel?.search(term: term)
		}
	}
}
