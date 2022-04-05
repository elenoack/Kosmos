
import Foundation

struct UserDefaultKey: RawRepresentable {
    let rawValue: String
}

extension UserDefaultKey: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        rawValue = value
    }
}
