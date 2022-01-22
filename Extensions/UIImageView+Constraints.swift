//
//  UIView+Constraints.swift
//  Homework14
//
//  Created by TMS on 13.11.2021.
//

import UIKit

extension UIImageView {
    
    enum Constants {
        static var meteoriteWidht: CGFloat = 125
    }
    
    func addSubviews() {
        self.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero - self.frame.height, width: Constants.meteoriteWidht, height: Constants.meteoriteWidht)
        self.contentMode = .scaleAspectFill
    }
}
