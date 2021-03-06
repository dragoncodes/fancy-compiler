//
// Created by dragoncodes on 16.04.18.

import Foundation

class RuleNode {
    let name: String

    let value: String

    var values: [String]

    var childRules = [ChildRule]()

    init(name: String, value: String) {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.value = value.trimmingCharacters(in: .whitespacesAndNewlines)

        self.values = [String]()
    }

    var description: String {
        return "\(name)  \(value)"
    }
}

extension RuleNode {
    func traverse(iteratorCallback: (String) -> ()) {

        if !values.isEmpty {
            for value in values {
                iteratorCallback(value)
            }
        } else {
            iteratorCallback(value)
        }
    }
}

class ChildRule {
    let selector: String

    let rawRule: String

    let value: String

    init(selector: String, rawRule: String, value: String) {
        self.selector = selector

        self.rawRule = rawRule

        self.value = value
    }
}

extension ChildRule {
    func isNodeEligible(node: FancyLanguageNode) -> Bool {

        if selector == "*" {
            return true
        }

        switch selector {
        case "*", ">":
            return true

        default:
            return false
        }

        return false
    }
}

extension Array where Element: RuleNode {
    func toDict() -> [String: String] {
        var parsedRules: [String: String] = [:]

        self.forEach { node in
            parsedRules[node.name] = node.value
        }

        return parsedRules
    }
}