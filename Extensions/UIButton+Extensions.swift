//
//  UIButton+Extensions.swift
//  Homework14
//
//  Created by TMS on 13.11.2021.
//

import UIKit

extension UIButton {
    
    convenience init(title: String?,
                     font: UIFont? = nil,
                     color: UIColor? = nil) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        if let font = font {
            titleLabel?.font = font
        }
        if let color = color {
            setTitleColor(color, for: .normal)
        }
    }
}
