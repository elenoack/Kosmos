//
//  PropertyListValue.swift
//  Kosmos
//
//  Created by TMS on 13.11.2021.
//


import Foundation

protocol PropertyListValue {}
extension String: PropertyListValue {}
extension Data: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}
extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
