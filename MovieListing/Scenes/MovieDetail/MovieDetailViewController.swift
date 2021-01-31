//
//  MovieDetailViewController.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 27.01.2021.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
	var presentationModel: MovieDetailPresentationModelProtocol? {
		get {
			return self.basePresentationModel as? MovieDetailPresentationModelProtocol
		}
		set {
			self.basePresentationModel = newValue
		}
	}

	// MARK: - ui controls
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var voteCountLabel: UILabel!
	@IBOutlet weak var voteAverageLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!

	// MARK: - members
	var isFavorite: Bool = false

	// MARK: - initialize
	override func viewDidLoad() {
		super.viewDidLoad()
		isFavorite = FavoritesManager.shared.isFavorite(id: presentationModel?.model.id)
		setupNavigationBar()
		setupUI()
	}

	// MARK: - custom methods
	private func setupUI() {
		backgroundImageView.load(from: presentationModel?.model.poster_path ?? "", contentMode: .scaleAspectFill,
								 placeholder: "placeholderWide")
		posterImageView.load(from: presentationModel?.model.poster_path ?? "", placeholder: "placeholderPortrait")
		titleLabel.text = presentationModel?.model.title
		descriptionLabel.text = presentationModel?.model.overview
		voteCountLabel.text = "Total Vote Count: \(presentationModel?.model.vote_count ?? 0)"
		voteAverageLabel.text = "Vote Average: \(presentationModel?.model.vote_average ?? 0)"
		if let date = presentationModel?.model.release_date {
			let formatter = DateFormatter()
			formatter.dateFormat = "dd.MM.yyyy"
			releaseDateLabel.text = "Release Date: \(formatter.string(from: date))"
		} else {
			releaseDateLabel.isHidden = true
		}
	}

	private func setupNavigationBar() {
		title = "Content Detail"
		setFavoriteButton(isFavorite: isFavorite)
	}

	private func setFavoriteButton(isFavorite: Bool) {
		let config = UIImage.SymbolConfiguration(weight: .light)
		var image: UIImage!

		if isFavorite {
			image = UIImage(systemName: "star.fill", withConfiguration: config)
		} else {
			image = UIImage(systemName: "star", withConfiguration: config)
		}

		let rightBarButton = UIBarButtonItem(image: image,
											 style: .plain,
											 target: self,
											 action: #selector(rightBarButtonAction))
		navigationItem.rightBarButtonItem = rightBarButton
	}

	@objc func rightBarButtonAction() {
		isFavorite ? presentationModel?.removeFromFavorite() : presentationModel?.addToFavorite()
	}
}

// MARK: - MovieDetailViewControllerProtocol methods
extension MovieDetailViewController: MovieDetailViewControllerProtocol {
	func handleOutput(_ output: MovieDetailPresentationModelOutput) {
		switch output {
		case .favoriteStatusChanged(let isFavorite):
			self.isFavorite = isFavorite
			setFavoriteButton(isFavorite: isFavorite)
		}
	}
}
