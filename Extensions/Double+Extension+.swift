//
//  extension Double.swift
//  Kosmos
//
//  Created by mac on 16.01.22.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
