//
//  Extensions.swift
//  GitHApp
//
//  Created by Marina Svistkova on 05.04.2021.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

