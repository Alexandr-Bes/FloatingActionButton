//
//  UIViewController+ext.swift
//  FloatActionButtonApp
//
//  Created by AlexBezkopylnyi on 08.03.2023.
//

import UIKit

extension UIViewController {
    /// Shows snack bar with animation and remove from superview once finished animating
    func showSnackbar(with message: String) {
        let snackBarView = BaseSnackbarView()
        self.view.addSubview(snackBarView)
        snackBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            snackBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15.0),
            snackBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            snackBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            snackBarView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40.0)
        ])

        snackBarView.showWithAnimationAndRemove(message: message)
        self.view.bringSubviewToFront(snackBarView)
    }
}
