//
//  Loading.swift
//  MovieListing
//
//  Created by Gökhan KOCA on 30.01.2021.
//

import UIKit

class Loading {

	class func show() {
		guard
			let view = UIApplication.shared.windows.first,
			!(view.subviews.contains(where: { $0.tag == 987 }))
		else { return }

		let backgroundView = UIView()
		backgroundView.tag = 987
		backgroundView.frame = UIScreen.main.bounds
		backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		let activityIndicator = UIActivityIndicatorView(style: .large)
		backgroundView.addSubview(activityIndicator)
		activityIndicator.center = backgroundView.center

		view.addSubview(backgroundView)
		activityIndicator.startAnimating()
	}

	class func hide() {
		UIApplication.shared.windows.first?.subviews.first(where: { $0.tag == 987 })?.removeFromSuperview()
	}
}
