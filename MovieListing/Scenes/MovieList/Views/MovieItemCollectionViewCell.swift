//
//  MovieItemCollectionViewCell.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 26.01.2021.
//

import UIKit

final class MovieItemCollectionViewCell: UICollectionViewCell {

	enum LayoutState {
		case grid
		case list
	}

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var favoriteImageView: UIImageView!

	var state: LayoutState = .grid

	override func awakeFromNib() {
		super.awakeFromNib()
		let config = UIImage.SymbolConfiguration(weight: .light)
		favoriteImageView.image = UIImage(systemName: "star.fill", withConfiguration: config)
	}

	func calculateParallax(collectionViewBounds: CGRect) {
		if state == .list {
			let offset = center.y - collectionViewBounds.midY
			let yRatio = offset / collectionViewBounds.size.height / 2
			posterImageView.layer.contentsRect = CGRect(x: 0, y: yRatio, width: 1, height: 1)
		}
	}
}
