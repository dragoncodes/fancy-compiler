//
// Created by dragoncodes on 16.04.18.

import Foundation

class RuleNode {
    let name: String

    let value: String

    init(name: String, value: String) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.value = value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var description: String {
        return "\(name)  \(value)"
    }
}